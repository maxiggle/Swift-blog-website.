import ButterCMSSDK
import Foundation
import Leaf
import Vapor

struct WebsiteController: RouteCollection {
  func boot(routes: RoutesBuilder) throws {
//    routes.get(use: handleArticleList)
    routes.get(use: handleArticleList)
  }

  func handleArticleList(_ req: Request) -> EventLoopFuture<View> {
    let pagesFuture = ButterCMSManager.shared.getPages(eventLoop: req.eventLoop)
    let landingPageFuture = ButterCMSManager.shared.getLandingPage(eventLoop: req.eventLoop)
      
    return pagesFuture
      .flatMap { pages in
          return landingPageFuture.flatMap { landingPages in
//              print(pages)
//              print("$$$$$$$$$$$")
              let typedPages = landingPages as [Page<LandingPageFields>]?
              let firstBlog = typedPages?.first?.fields.recentBlogs?.first?.fields.blog;
              firstBlog?.featuredPhoto
//              print(typedPages?.first?.fields.blog)
              let context = IndexContext(title: "Home page", pages: pages, landingPages: landingPages, firstBlog: firstBlog)
              return req.view.render("index", context)
          }
        
      }
  }
}

struct IndexContext: Encodable {
  let title: String
  let pages: [Page<BlogPageFields>]?
  let landingPages: [Page<LandingPageFields>]?
  let firstBlog: BlogPageFields?
}


