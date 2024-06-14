import UIKit

public class GenericCellRegistrator<Cell: BaseConfigurableCell>: CellRegistratorProtocol {

    private var cells: [Cell] = []

    public init() {}

    public func registerCells(in collectionView: UICollectionView) {
        collectionView.register(Cell.self, forCellWithReuseIdentifier: Cell.reuseIdentifier)
    }
}
