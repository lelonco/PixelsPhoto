import Foundation

public protocol URLRequestBuilder {
    var baseURL: URL { get }
    var requestURL: URL? { get }
    var path: String { get }
    var parameters: [String: Any]? { get }
    var method: String { get }
    var additionalHeaders: [String: String] { get }
    var customHTTPBody: Data? { get }
    var encoding: ParameterEncoding { get }
    var urlRequest: URLRequest? { get }
}

public extension URLRequestBuilder {

    var baseURL: URL {

        URL(string: "https://api.pexels.com")!
    }

    var requestURL: URL? {
        guard let path = baseURL.appendingPathComponent(path, isDirectory: false).absoluteString.removingPercentEncoding else {
            return nil
        }
        guard let url = URL(string: path) else {
            return nil
        }
        return url
    }

    var encoding: ParameterEncoding {
        switch method.lowercased() {
        case "get":
            .url
        default:
            .json
        }
    }

    var headers: [String: String] {
        var headers = [
            "Authorization": "Y7ADAmuk5dhGrohFuot7KYADCEkqI3EYeHsW4qH7iOXQvBUGThDUpNmM"
        ]
        for (key, value) in additionalHeaders {
            headers[key] = value
        }

        return headers
    }

    var urlRequest: URLRequest? {
        guard let url = requestURL else { return nil }
        var request = URLRequest(url: url)
        request.httpMethod = method
        for header in headers {
            request.addValue(header.value, forHTTPHeaderField: header.key)
        }
        request.httpBody = customHTTPBody
        return request
    }

    func asURLRequest() throws -> URLRequest {
        guard let request = urlRequest else { throw InternalApiError.invalidRequest }
        return try encoding.encode(request, with: parameters)
    }
}

public enum ParameterEncoding {
    case url
    case json

    func encode(_ request: URLRequest, with parameters: [String: Any]?) throws -> URLRequest {
        var request = request
        guard let parameters else { return request }

        switch self {
        case .url:
            if var urlComponents = URLComponents(url: request.url!, resolvingAgainstBaseURL: false), !parameters.isEmpty {
                let queryItems = parameters.map { URLQueryItem(name: $0.key, value: "\($0.value)") }
                urlComponents.queryItems = queryItems
                request.url = urlComponents.url
            }
        case .json:
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
        }
        return request
    }
}

enum InternalApiError: Error {
    case invalidRequest
}
