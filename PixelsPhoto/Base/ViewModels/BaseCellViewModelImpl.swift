import UIKit
import Combine

open class BaseCellViewModelImpl: Hashable, BaseCellViewModelProtocol, BaseCellConfigrator {
    public var cellCreator: any CellCreator
    @Published public var isSkeleton = false
    public var uuid: String {
        UUID().uuidString
    }

    public init(cellCreator: any CellCreator) {
        self.cellCreator = cellCreator
        cellCreator.viewModel = self
    }

    public static func == (lhs: BaseCellViewModelImpl, rhs: BaseCellViewModelImpl) -> Bool {
        lhs.uuid == rhs.uuid
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(uuid)
    }

    public func createCell(in collectionView: UICollectionView, for indexPath: IndexPath) -> UICollectionViewCell? {
        cellCreator.dequeueReusableCell(in: collectionView, indexPath: indexPath)
    }
}
