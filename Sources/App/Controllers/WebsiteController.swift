import Foundation
import Leaf
import Vapor
import ButterCMSSDK

struct WebsiteController: RouteCollection {
  func boot(routes: RoutesBuilder) throws {
//    routes.get(use: handleArticleList)
    routes.get(use: handleArticleList)
  }

  func handleArticleList(_ req: Request) -> EventLoopFuture<View> {
      let pagesFuture = ButterCMSManager.shared.getPages(eventLoop: req.eventLoop)
      
      return pagesFuture
          .flatMap { pages in
              print(pages)
                            let context = IndexContext(title: "Home page", pages: pages)
                            return req.view.render("index", context)
          }
        }

}

struct IndexContext: Encodable {
  let title: String
  let pages: [Page<BlogPageFields>]?
}

struct ArticleList: Encodable {
  var articleName: String
  var articleImage: String
  var articleDescription: String
}
