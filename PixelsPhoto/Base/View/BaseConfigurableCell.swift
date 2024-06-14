import UIKit

open class BaseConfigurableCell: UICollectionViewCell, Reusable, Configurable {

    var instanceReuse: String { Self.reuseIdentifier }

    override public init(frame: CGRect) {
        super.init(frame: frame)
    }

    @available(*, unavailable)
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    open func configure(with viewModel: BaseCellViewModelImpl) {
        assertionFailure("Need to override")
    }
}
