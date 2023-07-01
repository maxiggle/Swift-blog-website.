import Vapor
import Leaf
import Foundation


struct WebsiteController: RouteCollection {
  
  func boot(routes: RoutesBuilder) throws {
//    routes.get(use: handleArticleList)
    routes.get(use:handleArticleList)
  }

  
    func handleArticleList(_ req: Request) -> EventLoopFuture<View> {
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
            return [
                "articleName": article.articleName,
                "articleImage": article.articleImage,
                "articleDescription": article.articleDescription
                
            ]
        }
        
        
//        print(articleDictionaries)
        
        let context: [String: [[String:String]]] = [
            "articles": articleDictionaries,
//            "value": articles.count
        ]


         return req.view.render("index", context )
    }

  }


struct ArticleList: Encodable {
    var articleName: String
    var articleImage: String
    var articleDescription: String
}



