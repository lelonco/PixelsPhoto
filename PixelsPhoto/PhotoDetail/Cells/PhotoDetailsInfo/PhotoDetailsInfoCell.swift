import UIKit
import GenericCollection
import Combine
import SnapKit

class PhotoDetailsInfoCell: UICollectionViewCell, ConfigurableCell {
    typealias ViewModel = PhotoDetailsInfoViewModel
    var cellViewModel: ViewModel?
    var content: DetailsInfoView?
    var wrapedContent: WrapedView<DetailsInfoView>?
    func configure(with viewModel: ViewModel) {
        //
        cellViewModel = viewModel
        content = DetailsInfoView(viewModel: viewModel)
        wrapedContent = .init(view: content!)
        wrapedContent?.removeFromSuperview()
        contentView.addSubview(wrapedContent!)
        setupConstraints()
    }

    private func setupConstraints() {
        wrapedContent?.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    static var cellCreator: any CellCreator {
        GenericCellCreator<Self, ViewModel>()
    }
}
