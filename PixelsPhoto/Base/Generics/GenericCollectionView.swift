import UIKit
import Combine

protocol CollectionViewModel {}

protocol CollectionVCProtocol: CancellableStore {
    associatedtype ViewModel = BaseCollectionViewViewModel
    typealias Snapshot = NSDiffableDataSourceSnapshot<SectionViewModel, BaseCellViewModelImpl>
    var collectionView: UICollectionView { get set }
    var dataSource: UICollectionViewDiffableDataSource<SectionViewModel, BaseCellViewModelImpl> { get set }

    var viewModel: ViewModel { get set }

    func makeDatasource() -> UICollectionViewDiffableDataSource<SectionViewModel, BaseCellViewModelImpl>
    func setupLayout() -> UICollectionViewCompositionalLayout
    func applySnapshot(sections: [SectionViewModel], animatingDifferences: Bool)

    func defaultBind()
    func registerHeader(for dataSource: UICollectionViewDiffableDataSource<SectionViewModel, BaseCellViewModelImpl>)

    init(viewModel: ViewModel)
}

/// This is a generic protocol that implements the ``CollectionVCProtocol`` and adds default implementations to it.
/// If you want to use this class, subclass from it.
/// You should add a collectionView to the view and set up constraints.
/// The collectionView is configured, and its default implementation is marked as final. You shouldn't override it.

class GenericCollectionViewController<ViewModel: BaseCollectionViewViewModel>: UIViewController,
    CollectionVCProtocol,
    UICollectionViewDelegate {
    /// The collectionView instance used in this view controller.
    lazy var collectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: setupLayout())
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        view.delegate = self

        return view
    }()

    /// The dataSource instance for the collectionView.
    lazy var dataSource: UICollectionViewDiffableDataSource<SectionViewModel, BaseCellViewModelImpl> = makeDatasource()

    var cancellable = Set<AnyCancellable>()
    var viewModel: ViewModel

    /// Initializes the GenericCollectionViewController with a specified viewModel.
    ///
    /// - Parameter viewModel: The viewModel instance to use.
    required init(viewModel: ViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        defaultBind()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /// Creates and returns the CollectionViewDataSource instance.
    ///
    /// - Returns: The UICollectionViewDiffableDataSource instance.
    func makeDatasource() -> UICollectionViewDiffableDataSource<SectionViewModel, BaseCellViewModelImpl> {
        let dataSource = UICollectionViewDiffableDataSource<SectionViewModel, BaseCellViewModelImpl>(
            collectionView: collectionView,
            cellProvider: { collectionView, indexPath, cellVM -> UICollectionViewCell? in
                guard let cell = cellVM.createCell(in: collectionView, for: indexPath) else {
                    assertionFailure("Can't get cell")
                    return nil
                }
                return cell
            }
        )
        registerHeader(for: dataSource)
        return dataSource
    }

    /// Sets up and returns the UICollectionViewCompositionalLayout for the collectionView.
    ///
    /// - Returns: The UICollectionViewCompositionalLayout instance.
    final func setupLayout() -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout { [weak self]
            (sectionIndex: Int, _: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
                self?.viewModel.layoutType(for: IndexPath(row: 0, section: sectionIndex))
        }
        return layout
    }

    /// Applies a snapshot of the specified sections to the collectionView.
    ///
    /// - Parameters:
    ///   - sections: The sections to be displayed in the collectionView.
    ///   - animatingDifferences: A boolean value indicating whether to animate the differences.
    final func applySnapshot(sections: [SectionViewModel], animatingDifferences: Bool) {
        var snapshot = Snapshot()
        snapshot.appendSections(sections)
        for section in sections {
            snapshot.appendItems(section.items, toSection: section)
        }
        dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }

    /// Binds the viewModel's sectionPublisher to update the collectionView's content when the sections change.
    final func defaultBind() {
        viewModel.sectionPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] viewModels in
                self?.applySnapshot(sections: viewModels, animatingDifferences: true)
            }
            .store(in: &cancellable)
    }

    /// Registers a header for the specified data source. Override this method in a subclass if you want to use a header.
    func registerHeader(for dataSource: UICollectionViewDiffableDataSource<SectionViewModel, BaseCellViewModelImpl>) {
        assertionFailure("If you want to use a header, implement it in a subclass.")
    }

    // MARK: - UICollectionViewDelegate

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        viewModel.willDisplayCell(with: indexPath)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.didSelect(at: indexPath)
    }
}

// final class ContentAreaViewController: GenericCollectionViewController<ContentAreaViewModel> {
//    override func loadView() {
//        super.loadView()
//        [collectionView].forEach { self.view.addSubview($0) }
//        setupConstraints()
//    }
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        bind()
//    }
//
//    private func bind() {}
//
//    private func setupConstraints() {
//        collectionView.snp.makeConstraints { make in
//            make.edges.equalToSuperview()
//        }
//    }
//
//    override func registerHeader(
//        for dataSource: UICollectionViewDiffableDataSource<SectionViewModel, BaseCellViewModelImpl>
//    ) {
//        //
//    }
// }
