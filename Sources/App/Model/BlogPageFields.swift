import Foundation
import ButterCMSSDK

public struct BlogPageFields: Codable {
    var title, content, authorDetails, publishedDate: String?
    var slug: String?
    var featuredPhoto: String?
    var featuredAltText, summary: String?
}
