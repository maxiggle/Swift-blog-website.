import Foundation
import Leaf
import Vapor

struct WebsiteController: RouteCollection {
  func boot(routes: RoutesBuilder) throws {
//    routes.get(use: handleArticleList)
    routes.get(use: handleArticleList)
  }

  func handleArticleList(_ req: Request) -> EventLoopFuture<View> {
    ButterCMSManager.shared.getPages()

    ButterCMSManager.shared.blogPagesSubject
      .compactMap { value in
        value.data.compactMap { page in
          PageCellViewModel(page: page)
        }
      }
      .sink(
        receiveCompletion: { completion in
          switch completion {
          case .finished: break
          case let .failure(error): self.errorMessage.send(ErrorString.getString(error: error))
          }
        },
        receiveValue: { [weak self] value in self?.pages = value }
      )
      .store(in: &subscriptions)

    return req.view.render("index", context)
  }

  func indexHandler(_ req: Request) -> EventLoopFuture<View> {
    // 1
    let context = IndexContext(title: "Home page")
    // 2
    return req.view.render("index", context)
  }
}

struct IndexContext: Encodable {
  let title: String
}

struct ArticleList: Encodable {
  var articleName: String
  var articleImage: String
  var articleDescription: String
}
