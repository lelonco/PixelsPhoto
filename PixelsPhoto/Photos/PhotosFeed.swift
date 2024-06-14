import UIKit
import SnapKit

class PhotosFeed: GenericCollectionViewController<PhotosFeedViewModel> {

    override func loadView() {
        super.loadView()
        view.addSubview(collectionView)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupConstraints()
    }

    override func registerHeader(for dataSource: UICollectionViewDiffableDataSource<SectionViewModel, BaseCellViewModelImpl>) {
        //
    }

    func setupConstraints() {
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
