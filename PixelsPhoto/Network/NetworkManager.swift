import Foundation

public class NetworkManager {
    static let shared = NetworkManager()

    private init() {}

    func request<T: Decodable>(_ requestBuilder: URLRequestBuilder, responseType: T.Type) async throws -> T {
        guard let urlRequest = try? requestBuilder.asURLRequest() else {
            throw NetworkError.invalidRequest
        }

        let (data, response) = try await URLSession.shared.data(for: urlRequest)

        guard let httpResponse = response as? HTTPURLResponse, 200..<300 ~= httpResponse.statusCode else {
            throw NetworkError.invalidResponse
        }

        let decodedResponse = try JSONDecoder().decode(T.self, from: data)
        return decodedResponse
    }
}

public enum NetworkError: Error {
    case invalidRequest
    case invalidResponse
    case decodingError
}
