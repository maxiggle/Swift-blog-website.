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
      let values = ButterCMSManager.shared.blogPagesSubject;
      values.values;

    var articles = [ArticleList]()
    // Populate the articles array with some data
    let article1 = ArticleList(articleName: "Article 1", articleImage: "image1.jpg", articleDescription: "Description of Article 1")
    let article2 = ArticleList(articleName: "Article 2", articleImage: "image2.jpg", articleDescription: "Description of Article 2")
    let article3 = ArticleList(articleName: "Article 3", articleImage: "image3.jpg", articleDescription: "Description of Article 3")

    articles.append(article1)
    articles.append(article2)
    articles.append(article3)

//
    print("value: \(articles.count)")
    // Convert the array of ArticleList objects into an array of dictionaries

    let articleDictionaries = articles.map { article in
      [
        "articleName": article.articleName,
        "articleImage": article.articleImage,
        "articleDescription": article.articleDescription,
      ]
    }
    let context: [String: [[String: String]]] = [
      "articles": articleDictionaries,
      
    ]
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
