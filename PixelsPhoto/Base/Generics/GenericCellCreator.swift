import UIKit

public class GenericCellCreator<Cell: BaseConfigurableCell, ViewModel: BaseCellViewModelImpl>: CellCreator where ViewModel == Cell.ViewModel {

    public weak var viewModel: BaseCellViewModelImpl?
    private var customConfiguration: ((Cell?) -> Void)?
    private var cellRegistrator: GenericCellRegistrator<Cell>

    public init() {
        cellRegistrator = GenericCellRegistrator<Cell>()
    }

    public func dequeueReusableCell(in collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell? {
        cellRegistrator.registerCells(in: collectionView)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Cell.reuseIdentifier,
                                                      for: indexPath) as? Cell
        if let viewModel = viewModel as? ViewModel {
            cell?.configure(with: viewModel)
        }
        customConfiguration?(cell)
        return cell
    }

    @discardableResult
    public func registerCustomConfiguration(config: @escaping ((Cell?) -> Void)) -> Self {
        customConfiguration = config
        return self
    }

    @discardableResult
    public func storeRegistrator(in registrators: inout [CellRegistratorProtocol]) -> Self {
        registrators.append(cellRegistrator)
        return self
    }
}
