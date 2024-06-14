import UIKit
import Combine

class PhotosFeedViewModel: BaseCollectionViewViewModel {
    @Published private var sections: [SectionViewModel] = []
    var sectionPublisher: AnyPublisher<[SectionViewModel], Never> {
        $sections.eraseToAnyPublisher()
    }

    var cancellable = Set<AnyCancellable>()

    let networkService: IPhotosService
    let perPage = 15
    var currentPage = 0
    init(networkService: IPhotosService) {
        self.networkService = networkService
        getData()
    }

    private func getData() {
        Task {
            do {
                let data = try await networkService.getCurated(page: currentPage, perPage: perPage)
                print(data)
            } catch {
                print(error)
            }
        }
    }

    func layoutType(for indexPath: IndexPath) -> NSCollectionLayoutSection? {
        nil
    }

    func willDisplayCell(with indexPath: IndexPath) {
        //
    }

    func didSelect(at indexPath: IndexPath) {
        //
    }
}
