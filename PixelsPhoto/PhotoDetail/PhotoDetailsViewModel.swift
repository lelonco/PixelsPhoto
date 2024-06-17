import Combine
import GenericCollection
import UIKit

class PhotoDetailsViewModel: BaseCollectionViewViewModel {

    var cancellable = Set<AnyCancellable>()

    private var predefinedSections: [PhotoDetailsSections] = [.header, .info, .related]
    @Published private var sections: [CustomSectionViewModel<PhotoDetailsSections>] = []

    var sectionPublisher: AnyPublisher<[SectionViewModel], Never> {
        $sections
            .map { sections in
                sections.map { $0 as SectionViewModel }
            }
            .eraseToAnyPublisher()
    }

    private let photo: Photo
    private let page: PexelsResponse
    private let preloadedPhoto: UIImage?
    init(photo: Photo, page: PexelsResponse, preloadedPhoto: UIImage?) {
        self.photo = photo
        self.page = page
        self.preloadedPhoto = preloadedPhoto
        setupSections()
    }

    func layoutType(for indexPath: IndexPath) -> NSCollectionLayoutSection? {
        sections[indexPath.section].layout
    }

    func willDisplayCell(with indexPath: IndexPath) {
        //
    }

    func didSelect(at indexPath: IndexPath) {
        guard sections[indexPath.section].sectionType == .related else { return }
        // Move to related photo
    }
}

// MARK: - Sections setup
private extension PhotoDetailsViewModel {
    func setupSections() {
        fillSections()
        fillItems()
    }

    func fillItems() {
        for section in sections {
            switch section.sectionType {
            case .header: fillHeader(section: section)
            case .info: fillInfo(section: section)
            case .related: fillRelated(section: section)
            }
        }
    }

    func fillInfo(section: CustomSectionViewModel<PhotoDetailsSections>) {
        guard section.sectionType == .info else { return }
        section.items = [PhotoDetailsInfoViewModel(photo: photo, cellCreator: PhotoDetailsInfoCell.cellCreator)]

        addSection(section: section)
    }

    func fillRelated(section: CustomSectionViewModel<PhotoDetailsSections>) {
        guard section.sectionType == .related else { return }
        let photos = page.photos.filter { $0.id != photo.id }
        section.items = photos.map { PhotoImageViewModel(model: $0, cellCreator: ImageCell.cellCreator) }

        addSection(section: section)
    }

    func fillHeader(section: CustomSectionViewModel<PhotoDetailsSections>) {
        guard section.sectionType == .header else { return }
        section.items = [PhotoDetailsHeaderViewModel(photo: photo, image: preloadedPhoto, cellCreator: DetailsHeaderCell.cellCreator)]

        addSection(section: section)
    }

    func addSection(section: CustomSectionViewModel<PhotoDetailsSections>) {
        guard !sections.contains(section) else { return }
        sections.append(section)
    }

    func fillSections() {
        sections = predefinedSections.map { section in
            let customSection = CustomSectionViewModel<PhotoDetailsSections>(sectionType: section)
            customSection.title = section.title
            customSection.layout = section.layout
            return customSection
        }
    }
}

// MARK: - Sections

private extension PhotoDetailsViewModel {
    enum PhotoDetailsSections: SectionLayoutType {

        case header
        case info
        case related

        var title: String? {
            switch self {
            case .header, .info: nil
            case .related: "Related"
            }
        }

        var layout: NSCollectionLayoutSection {
            switch self {
            case .header: PhotoDetailsHeaderLayout()
            case .info: PhotoDetailsHeaderLayout()
            case .related: PhotoDetailsHeaderLayout()
            }
        }
    }
}
