import UIKit

public protocol BaseConfigurableCell: UICollectionViewCell, Configurable, Reusable {
    associatedtype ViewModel
    var cellViewModel: ViewModel? { get set }

    func configure(with viewModel: ViewModel)
}
