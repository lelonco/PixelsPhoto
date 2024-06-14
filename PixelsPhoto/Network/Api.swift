import Foundation

enum PhotosAPI: URLRequestBuilder {
    case curated(perPage: Int, currenPage: Int)
}

extension PhotosAPI {
    var path: String {
        switch self {
        case .curated:
            "v1/curated"
        }
    }

    var parameters: [String: Any]? {
        switch self {
        case let .curated(perPage, currenPage):
            [
                "per_page": perPage,
                "page": currenPage
            ]
        }
    }

    var method: String {
        "GET"
    }

    var additionalHeaders: [String: String] {
        [:]
    }

    var customHTTPBody: Data? {
        nil
    }
}
