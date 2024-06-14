import Foundation

struct PexelsResponse: Codable {
    let page: Int
    let perPage: Int
    let photos: [Photo]
    let nextPage: String

    enum CodingKeys: String, CodingKey {
        case page
        case perPage = "per_page"
        case photos
        case nextPage = "next_page"
    }
}

struct Photo: Codable {
    let id: Int
    let width: Int
    let height: Int
    let url: String
    let photographer: String
    let photographerUrl: String
    let photographerId: Int
    let avgColor: String
    let src: PhotoSource
    let liked: Bool
    let alt: String

    enum CodingKeys: String, CodingKey {
        case id
        case width
        case height
        case url
        case photographer
        case photographerUrl = "photographer_url"
        case photographerId = "photographer_id"
        case avgColor = "avg_color"
        case src
        case liked
        case alt
    }
}

struct PhotoSource: Codable {
    let original: String?
    let large2x: String?
    let large: String?
    let medium: String?
    let small: String?
    let portrait: String?
    let landscape: String?
    let tiny: String?
}
