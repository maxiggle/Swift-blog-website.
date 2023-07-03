import Vapor

func routes(_ app: Application) throws {
     let websiteController = WebsiteController()
     try app.register(collection: websiteController)
   
//   app.get("index") { req -> String in
//    let websiteController = WebsiteController()
//    try app.register(collection: websiteController)
//   }
//
//   app.get("blog") { req -> String in
//    let blogController = BlogController()
//    try app.register(collection: blogController)
//   }

}
