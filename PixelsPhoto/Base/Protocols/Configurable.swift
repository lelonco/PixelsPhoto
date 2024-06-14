import Foundation

public protocol Configurable: AnyObject {

    func configure(with viewModel: BaseCellViewModelImpl)
}
