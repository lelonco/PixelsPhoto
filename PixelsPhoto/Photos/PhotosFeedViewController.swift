import UIKit
import SnapKit
import GenericCollection

class PhotosFeedViewController: GenericCollectionViewController<PhotosFeedViewModel> {
    private let refreshControl = UIRefreshControl()

    override func loadView() {
        super.loadView()
        view.backgroundColor = .white
        view.addSubview(collectionView)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupConstraints()
        collectionView.prefetchDataSource = self
        setupPullToRefresh()
    }

    override func viewWillTransition(to size: CGSize, with coordinator: any UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        viewModel.invalidateLayouts()
        collectionView.collectionViewLayout.invalidateLayout()
    }

    override func registerHeader(for dataSource: UICollectionViewDiffableDataSource<SectionViewModel, BaseCellViewModelImpl>) {
        //
    }

    private func setupPullToRefresh() {
        collectionView.alwaysBounceVertical = true
        collectionView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
    }

    func setupConstraints() {
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    @objc
    private func refreshData(_ sender: UIRefreshControl) {
        // Implement your data fetching logic here
        // For example, you might want to call viewModel.fetchLatestPhotos()

        Task { [unowned self] in
            await viewModel.reloadData()
            DispatchQueue.main.async {
                self.refreshControl.endRefreshing()
            }
        }
    }
}

extension PhotosFeedViewController: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        viewModel.prefetchItemsAt(indexPaths: indexPaths)
    }
}
