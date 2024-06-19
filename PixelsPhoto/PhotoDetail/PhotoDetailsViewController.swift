import UIKit
import GenericCollection

class PhotoDetailsViewController: GenericCollectionViewController<PhotoDetailsViewModel> {

    override func loadView() {
        super.loadView()
        view.addSubview(collectionView)
        view.backgroundColor = .white
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        bind()
    }

    override func viewDidDisappear(_ animated: Bool) {
        viewModel.didDisappear()
    }

    private func bind() {
        viewModel.reloadData
            .sink { [weak self] _ in
                guard let self else { return }
                let snapshot = dataSource.snapshot()
                dataSource.apply(snapshot, animatingDifferences: true, completion: nil)
            }
            .store(in: &cancellable)
    }

    override func viewWillTransition(to size: CGSize, with coordinator: any UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        viewModel.invalidateLayouts()
        collectionView.collectionViewLayout.invalidateLayout()
    }

    override func registerHeader(for _: UICollectionViewDiffableDataSource<SectionViewModel, BaseCellViewModelImpl>) {
        //
    }
}
