import UIKit
import Combine

protocol CustomSectionViewModelProtocol: SectionViewModel {
    associatedtype SectionType: SectionLayoutType
    var sectionType: SectionType { get set }
    init(sectionType: SectionType)
}

class CustomSectionViewModel<T: SectionLayoutType>: SectionViewModel, CustomSectionViewModelProtocol {
    var sectionType: T

    required init(sectionType: T) {
        self.sectionType = sectionType
        super.init()
        title = sectionType.title
    }

    override func copy() -> SectionViewModel {
        Self(sectionType: sectionType)
    }
}

open class SectionViewModel: Hashable, ObservableObject {
    private(set) var uuid = UUID()
    public var title: String?
    @Published public var items: [BaseCellViewModelImpl] = [] {
        didSet {
            objectWillChange.send()
        }
    }

    public var layout: NSCollectionLayoutSection?

    private init(uuid: UUID, title: String?, items: [BaseCellViewModelImpl]) {
        self.uuid = uuid
        self.title = title
        self.items = items
    }

    public init() {}

    // MARK: - Hashable

    public static func == (lhs: SectionViewModel, rhs: SectionViewModel) -> Bool {
        lhs.uuid == rhs.uuid
    }

    open func copy() -> SectionViewModel {
        SectionViewModel(uuid: uuid, title: title, items: items)
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(uuid)
    }
}
