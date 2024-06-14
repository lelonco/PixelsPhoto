import UIKit

public protocol BaseCellConfigrator {
    var cellCreator: CellCreator { get set }

    func createCell(in collectionView: UICollectionView, for indexPath: IndexPath) -> UICollectionViewCell?
}
