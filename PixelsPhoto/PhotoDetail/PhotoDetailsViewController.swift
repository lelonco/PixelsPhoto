import UIKit
import GenericCollection

class PhotoDetailsViewController: GenericCollectionViewController<PhotoDetailsViewModel> {

    override func loadView() {
        super.loadView()
        view.addSubview(collectionView)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    override func registerHeader(for _: UICollectionViewDiffableDataSource<SectionViewModel, BaseCellViewModelImpl>) {
        //
    }
}
