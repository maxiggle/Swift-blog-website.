import Foundation
import ButterCMSSDK

public struct BlogPageFields: Codable {
    var title, content, authorDetails, publishedDate: String?
    var slug: String?
    var featuredPhoto: String?
    var featuredAltText, summary: String?
}

 


public struct LandingPageFields: Codable {
    let heroSection: HeroSection?
    let recentBlogs: [Page<NestedBlogFields>]?

}


struct HeroSection: Codable {
    let heroimage: String?
    let headline: String?
}

//struct RecentBlog: Codable {
//    let fields: Fields
//
//}
//
struct NestedBlogFields: Codable {
    let blog: BlogPageFields?
}


