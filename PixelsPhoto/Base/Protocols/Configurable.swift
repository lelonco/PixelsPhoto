import Foundation

public protocol Configurable: AnyObject {
    associatedtype ViewModel = BaseCellViewModelImpl
    func configure(with viewModel: ViewModel)
}
