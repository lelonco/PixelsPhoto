import UIKit

public protocol CellCreator: AnyObject {
    var viewModel: BaseCellViewModelImpl? { get set }
    func dequeueReusableCell(in collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell?
}
