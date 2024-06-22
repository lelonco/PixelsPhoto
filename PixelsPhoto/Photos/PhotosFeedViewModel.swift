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
    private var isLoading = false
    let networkService: IPhotosService
    let perPage = 15
    var currentPage = 1
    private var pages: [PexelsResponse] = []
    init(networkService: IPhotosService) {
        self.networkService = networkService
        getData(currentPage: currentPage, perPage: perPage)
    }

    private func fill(using data: PexelsResponse) {
        pages.append(data)
        isLoading = false
        let section = getSection(for: .feed)
        section.layout = PhotosFeedSection.feed.layout
        let newItems = data.photos
            .map {
                PhotoImageViewModel(model: $0, relatesTo: data, cellCreator: ImageCell.cellCreator)
            }
            .filter { item in
                !section.items.contains {
                    $0.uuid == item.uuid
                }
            }
        section.items += newItems
        sections = [section]
    }

    private func getSection(for type: PhotosFeedSection) -> CustomSectionViewModel<PhotosFeedSection> {
        sections.first { $0.sectionType == type } ?? CustomSectionViewModel<PhotosFeedSection>(sectionType: type)
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

    func loadMore() {
        guard !isLoading else { return }
        isLoading = true
        currentPage += 1
        getData(currentPage: currentPage, perPage: perPage)
    }

    private func getData(currentPage: Int, perPage: Int) {
        Task {
            await self.asyncGetData(currentPage: currentPage, perPage: perPage)
        }
    }

    func asyncGetData(currentPage: Int, perPage: Int) async {
        do {
            let data = try await networkService.getCurated(page: currentPage, perPage: perPage)
            fill(using: data)
        } catch {

            let retry = await coordinator?.showError(error: error) ?? false
            if retry {
                await asyncGetData(currentPage: currentPage, perPage: perPage)
            }
        }
    }

    func reloadData() async {
        pages = []
        sections = []
        await asyncGetData(currentPage: 0, perPage: perPage)
    }

    func prefetchItemsAt(indexPaths: [IndexPath]) {
        let itemIndices = indexPaths.map(\.item).sorted()
        guard let sectionItemsCount = sections.first?.items.count,
              let greatesIndex = itemIndices.last,
              (sectionItemsCount - 1) <= greatesIndex else { return }

        loadMore()
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
