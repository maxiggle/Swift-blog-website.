import ButterCMSSDK
import Foundation
import Leaf
import Vapor
import SwiftSoup
import JavaScriptCore
import wkhtmltopdf

struct WebsiteController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        routes.get(use: homepageHandler)
        routes.get("blog", ":blogSlug", use: blogHandler)
        routes.get("blogs", use: blogsHandler)
        routes.get("search", use: searchHandler)
        routes.get("download", ":blogSlug", use: downloadPageHandler)
    }
    
    
    func homepageHandler(_ req: Request) -> EventLoopFuture<View> {
        let pagesFuture = ButterCMSManager.shared.getPages(eventLoop: req.eventLoop)
        let landingPageFuture = ButterCMSManager.shared.getLandingPage(eventLoop: req.eventLoop)
        
        
        return pagesFuture
            .flatMap { pages in
                return landingPageFuture.flatMap { landingPages in
                    let typedPages = landingPages as [ButterCMSSDK.Page<LandingPageFields>]?
                    print(pages.count)
                    let firstBlog = typedPages?.first?.fields.recentBlogs?.first?.fields.blog;
                    let blogs = typedPages?.first?.fields.recentBlogs?.map({ val in
                        return val.fields.blog
                    })
                    
                    
                    let context = IndexContext(title: "Home page", pages: pages, landingPages: landingPages, firstBlog: firstBlog, blogs: blogs)
                    return req.view.render("index", context)
                }
                
            }
    }
    
    
    func blogHandler(_ req: Request) -> EventLoopFuture<View> {
       
        let slug = req.parameters.get("blogSlug")
        
        let landingPageFuture = ButterCMSManager.shared.getLandingPage(eventLoop: req.eventLoop)
        
        
        return landingPageFuture.flatMap { landingPages in
            let typedPages = landingPages as [ButterCMSSDK.Page<LandingPageFields>]?
            let blogs = typedPages?.first?.fields.recentBlogs?.map({ val in
                return val.fields.blog
            })
            let selectedBlog = findBlogFromSlug(slug: slug, blogs: blogs)
            let blogAnchors = getBlogAnchors(selectedBlog: selectedBlog)
            
            
            let context = BlogContext(title: slug, blog: selectedBlog, blogAnchors: blogAnchors)
            
            return req.view.render("blog", context)
        }
    }
    
    func getBlogAnchors(selectedBlog: BlogPageFields?) -> [BlogAnchor]{
        var idValues: [BlogAnchor] = [];
        
        do {
            if let html = selectedBlog?.content {
                let doc: SwiftSoup.Document = try SwiftSoup.parse(html)
                
                // Extract specific tags
                let allTags: Elements = try doc.select("*") // Extract all tags
                
                // Iterate over the extracted tags
                for tag in allTags {
                    let link = try tag.attr("id")
                    let title = link.capitalized.replacingOccurrences(of: "-", with: " ")
                    idValues.append(BlogAnchor(title: title, link: link))
                }
            }
        } catch {
            print("Error parsing HTML: \(error)")
        }
        return idValues;
    }
    
    
    
    
    
    func findBlogFromSlug(slug: String?, blogs: [BlogPageFields?]?) -> BlogPageFields? {
        if let unwrappedBlogs = blogs {
            return unwrappedBlogs.compactMap { $0 }.first { val in
                val.slug == slug
            }
        } else {
            return nil
        }
    }
    
    
    func blogsHandler(_ req: Request) -> EventLoopFuture<View> {
        let landingPageFuture = ButterCMSManager.shared.getLandingPage(eventLoop: req.eventLoop)
        
        return landingPageFuture.flatMap { landingPages in
            let typedPages = landingPages as [ButterCMSSDK.Page<LandingPageFields>]?
            let blogs = typedPages?.first?.fields.recentBlogs?.map({ val in
                return val.fields.blog
            })
            let context = BlogsContext(title: "Blogs", blogs: blogs)
            return req.view.render("blogs", context)
        }
    }
    
    func searchHandler(_ req: Request) -> EventLoopFuture<View> {
        let searchTerm = req.query[String.self, at: "text"]
        let landingPageFuture = ButterCMSManager.shared.getLandingPage(eventLoop: req.eventLoop)
        
        return landingPageFuture.flatMap { landingPages in
            let typedPages = landingPages as [ButterCMSSDK.Page<LandingPageFields>]?
            let blogs = typedPages?.first?.fields.recentBlogs?.map({ val in
                return val.fields.blog
            })
            
            let searchResults = searchArticlesByName(blogs: blogs, searchTerm: searchTerm)
            let context = SearchContext(title: searchTerm, blogs: searchResults)
            return req.view.render("search", context)
        }
        
    }
    
    func searchArticlesByName(blogs: [BlogPageFields?]?, searchTerm: String?) -> [BlogPageFields] {
        guard let searchTerm = searchTerm, !searchTerm.isEmpty else {
            return blogs?.compactMap { $0 } ?? []
        }
        
        let filteredBlogs = blogs?.compactMap { $0 }.filter { blog in
            if let title = blog.title {
                return title.localizedCaseInsensitiveContains(searchTerm)
            }
            return false
        }
        
        return filteredBlogs ?? []
    }
    
    
    func downloadPageHandler(_ req: Request) -> EventLoopFuture<Response> {
        let document = Document(margins: 15)
        let slug = req.parameters.get("blogSlug")
        let landingPageFuture = ButterCMSManager.shared.getLandingPage(eventLoop: req.eventLoop)
        
        
        return landingPageFuture.flatMap { landingPages in
            let typedPages = landingPages as [ButterCMSSDK.Page<LandingPageFields>]?
            let blogs = typedPages?.first?.fields.recentBlogs?.map({ val in
                return val.fields.blog
            })
            let selectedBlog = findBlogFromSlug(slug: slug, blogs: blogs)
            let blogAnchors = getBlogAnchors(selectedBlog: selectedBlog)
            
            let context = BlogContext(title: slug, blog: selectedBlog, blogAnchors: blogAnchors)
            let renderPage = req.view.render("download", context)
            let pages = [renderPage]
                .flatten(on: req.eventLoop)
                .map { views in
                    views.map { Page($0.data) }
                }
            
            return pages.flatMap { pages in
                // Add the pages to the document
                document.pages = pages
                // Render to a PDF
                let pdf = document.generatePDF(on: req.application.threadPool, eventLoop: req.eventLoop)
                // Now you can return the PDF as a response, if you want
                return pdf.map { data in
                    return Response(
                        status: .ok,
                        headers: HTTPHeaders([("Content-Type", "application/pdf")]),
                        body: .init(data: data)
                    )
                }
            }
        }
    }
    
//    func extractPTag(selectedBlog: BlogPageFields?) -> [ExtractTagContext]? {
//        var tags: [ExtractTagContext] = []
//        do {
//            if let html = selectedBlog?.content {
//                let doc: SwiftSoup.Document = try SwiftSoup.parse(html)
//                let allTags: Elements = try doc.select("p")
//                tags.append(ExtractTagContext(pTag: try allTags.toString()))
//            }
//
//        } catch {
//            print("Error parsing HTML: \(error)")
//        }
//        print(tags)
//
//        return tags
//    }
}

struct IndexContext: Encodable {
  let title: String
    let pages: [ButterCMSSDK.Page<BlogPageFields>]?
    let landingPages: [ButterCMSSDK.Page<LandingPageFields>]?
  let firstBlog: BlogPageFields?
  let blogs: [BlogPageFields?]?
    
}

struct BlogContext: Encodable {
  let title: String?
  let blog: BlogPageFields?
  let blogAnchors: [BlogAnchor]?
   
}

struct BlogsContext: Encodable {
  let title: String?
  let blogs: [BlogPageFields?]?
}

struct BlogAnchor: Encodable {
  let title: String?
  let link: String?
}

struct SearchContext: Encodable {
    let title: String?
    let blogs: [BlogPageFields]
}


struct ExtractTagContext: Encodable {
    let pTag: String?
}
