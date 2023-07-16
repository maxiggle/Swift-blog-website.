import Vapor

func routes(_ app: Application) throws {
     let websiteController = WebsiteController()
     try app.register(collection: websiteController)
//    let newController = JsController()
//    try app.register(collection: newController)
}
