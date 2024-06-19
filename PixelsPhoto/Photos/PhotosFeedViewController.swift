import UIKit
import SnapKit
import GenericCollection

class PhotosFeedViewController: GenericCollectionViewController<PhotosFeedViewModel> {

    override func loadView() {
        super.loadView()
        view.backgroundColor = .white
        view.addSubview(collectionView)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupConstraints()
    }

    override func viewWillTransition(to size: CGSize, with coordinator: any UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        viewModel.invalidateLayouts()
        collectionView.collectionViewLayout.invalidateLayout()
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
