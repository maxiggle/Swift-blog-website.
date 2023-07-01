import Foundation
import ButterCMSSDK

struct BlogPageFields: Codable {
    var title, content, authorDetails, publishedDate: String
    var slug: String
    var featuredPhoto: String
    var featuredAltText, summary: String

    enum CodingKeys: String, CodingKey {
        case title, content
        case authorDetails = "author_details"
        case publishedDate = "published_date"
        case slug
        case featuredPhoto = "featured_photo"
        case featuredAltText = "featured_alt_text"
        case summary
    }
}
