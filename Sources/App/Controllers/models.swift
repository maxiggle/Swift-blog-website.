
import Foundation

// MARK: - LandingPageResponse
//struct LandingPageResponse: Codable {
//    let slug, name, published, updated: String
//    let pageType: String
//    let fields: LandingPageResponseFields
//
//    enum CodingKeys: String, CodingKey {
//        case slug, name, published, updated
//        case pageType = "page_type"
//        case fields
//    }
//}

// MARK: - LandingPageResponseFields
//struct LandingPageResponseFields: Codable {
//    let heroSection: HeroSection
//    let recentBlogs: [FeaturedBlogs]
//    let featuredBlogs: FeaturedBlogs
//
//    enum CodingKeys: String, CodingKey {
//        case heroSection = "hero_section"
//        case recentBlogs = "recent_blogs"
//        case featuredBlogs = "featured_blogs"
//    }
//}

// MARK: - FeaturedBlogs
//struct FeaturedBlogs: Codable {
//    let slug, name, published, updated: String
//    let pageType: String
//    let fields: FeaturedBlogsFields
//
//    enum CodingKeys: String, CodingKey {
//        case slug, name, published, updated
//        case pageType = "page_type"
//        case fields
//    }
//}

// MARK: - FeaturedBlogsFields
//struct FeaturedBlogsFields: Codable {
//    let blog: Blog
//}

// MARK: - Blog
//struct Blog: Codable {
//    let title, content, authorDetails, publishedDate: String
//    let slug: String
//    let featuredPhoto: String
//    let featuredAltText, summary: String
//
//    enum CodingKeys: String, CodingKey {
//        case title, content
//        case authorDetails = "author_details"
//        case publishedDate = "published_date"
//        case slug
//        case featuredPhoto = "featured_photo"
//        case featuredAltText = "featured_alt_text"
//        case summary
//    }
//}

// MARK: - HeroSection
//struct HeroSection: Codable {
//    let heroimage: String
//    let headline: String
//}


//func callApi() async throws -> LandingPageResponse{
//    //let endpoint
//}
