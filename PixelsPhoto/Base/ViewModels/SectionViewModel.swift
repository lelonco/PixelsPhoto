import UIKit
import Combine

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
