import ButterCMSSDK
import Foundation
import Leaf
import Vapor

struct WebsiteController: RouteCollection {
  func boot(routes: RoutesBuilder) throws {
   routes.get(use: handleArticleList)
   routes.get("blog", ":blogSlug", use: blogHandler)
   routes.get("blogs", use: blogsHandler)
  }

  func handleArticleList(_ req: Request) -> EventLoopFuture<View> {
    let pagesFuture = ButterCMSManager.shared.getPages(eventLoop: req.eventLoop)
    let landingPageFuture = ButterCMSManager.shared.getLandingPage(eventLoop: req.eventLoop)
      
    return pagesFuture
      .flatMap { pages in
          return landingPageFuture.flatMap { landingPages in
              let typedPages = landingPages as [Page<LandingPageFields>]?
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
            let typedPages = landingPages as [Page<LandingPageFields>]?
            let blogs = typedPages?.first?.fields.recentBlogs?.map({ val in
                  return val.fields.blog
              })
            let selectedBlog = findBlogFromSlug(slug: slug, blogs: blogs)

            let context = BlogContext(title: slug, blog: selectedBlog)
            return req.view.render("blog", context)
        }
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
            let typedPages = landingPages as [Page<LandingPageFields>]?
            let blogs = typedPages?.first?.fields.recentBlogs?.map({ val in
                  return val.fields.blog
              })

            let context = BlogsContext(title: "Blogs", blogs: blogs)
            return req.view.render("blogs", context)
        }
      }
}

struct IndexContext: Encodable {
  let title: String
  let pages: [Page<BlogPageFields>]?
  let landingPages: [Page<LandingPageFields>]?
  let firstBlog: BlogPageFields?
  let blogs: [BlogPageFields?]?
}

struct BlogContext: Encodable {
  let title: String?
  let blog: BlogPageFields?
}

struct BlogsContext: Encodable {
  let title: String?
    let blogs: [BlogPageFields?]?
}
