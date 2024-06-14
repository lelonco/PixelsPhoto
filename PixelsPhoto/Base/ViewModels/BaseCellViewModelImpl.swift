import UIKit
import Combine

open class BaseCellViewModelImpl: Hashable, BaseCellViewModelProtocol, BaseCellConfigrator {
    public var cellCreator: CellCreator
    @Published public var isSkeleton = false
    public let uuid = UUID()

    public init(cellCreator: CellCreator) {
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
