import UIKit
import Combine
import GenericCollection

class PhotosFeedViewModel: BaseCollectionViewViewModel {
    weak var coordinator: PhotosFeedCoordinator?
    @Published private var sections: [CustomSectionViewModel<PhotosFeedSection>] = []
    var sectionPublisher: AnyPublisher<[SectionViewModel], Never> {
        $sections
            .map { sections in
                sections.map { $0 as SectionViewModel }
            }
            .eraseToAnyPublisher()
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
                fill(using: data)
            } catch {
                print(error)
            }
        }
    }

    private func fill(using data: PexelsResponse) {
        let section = CustomSectionViewModel<PhotosFeedSection>(sectionType: .feed)
        section.layout = PhotosFeedSection.feed.layout
        section.items = data.photos.map {
            PhotoImageViewModel(model: $0, relatesTo: data, cellCreator: ImageCell.cellCreator)
        }
        sections = [section]
    }

    func invalidateLayouts() {
        for section in sections {
            section.layout = section.sectionType.layout
        }
    }

    func layoutType(for indexPath: IndexPath) -> NSCollectionLayoutSection? {
        sections[indexPath.section].layout
    }

    func willDisplayCell(with indexPath: IndexPath) {
        //
    }

    func didSelect(at indexPath: IndexPath) {
        let section = sections[indexPath.section]
        let item = section.items[indexPath.item]
        guard let photo = item as? PhotoImageViewModel else { return }
        coordinator?.openDetails(for: photo)
    }
}

private extension PhotosFeedViewModel {
    enum PhotosFeedSection: SectionLayoutType {
        case feed
        var layout: NSCollectionLayoutSection {
            switch self {
            case .feed: PhotoFeedLayout()
            }
        }

        var title: String? {
            switch self {
            case .feed: nil
            }
        }
    }
}
