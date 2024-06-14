import Foundation

protocol IPhotosService {
    func getCurated(page: Int, perPage: Int) async throws -> PexelsResponse
}

class PhotosService: IPhotosService {

    func getCurated(page: Int = 0, perPage: Int = 15) async throws -> PexelsResponse {

        let request = PhotosAPI.curated(perPage: perPage, currenPage: page)

        return try await NetworkManager.shared.request(request, responseType: PexelsResponse.self)
    }
}
