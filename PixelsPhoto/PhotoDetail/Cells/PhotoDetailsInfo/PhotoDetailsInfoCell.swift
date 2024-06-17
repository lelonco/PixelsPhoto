import UIKit
import GenericCollection
import Combine

class PhotoDetailsInfoCell: UICollectionViewCell, ConfigurableCell {
    typealias ViewModel = PhotoDetailsInfoViewModel
    var cellViewModel: ViewModel?

    func configure(with viewModel: ViewModel) {
        //
    }

    static var cellCreator: any CellCreator {
        GenericCellCreator<Self, ViewModel>()
    }
}
