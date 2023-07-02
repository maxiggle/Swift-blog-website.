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
              print(pages)
              print("$$$$$$$$$$$")
              print(landingPages)
              let context = IndexContext(title: "Home page", pages: pages, landingPages: landingPages)
              return req.view.render("index", context)
          }
        
      }
  }
}

struct IndexContext: Encodable {
  let title: String
  let pages: [Page<BlogPageFields>]?
  let landingPages: [Page<LandingPageFields>]?
}

struct ArticleList: Encodable {
  var articleName: String
  var articleImage: String
  var articleDescription: String
}
