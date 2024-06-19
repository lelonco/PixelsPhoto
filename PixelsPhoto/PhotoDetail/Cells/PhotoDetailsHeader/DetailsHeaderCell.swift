import UIKit
import Combine
import GenericCollection

class DetailsHeaderCell: UICollectionViewCell, BaseConfigurableCell {
    typealias ViewModel = PhotoDetailsHeaderViewModel

    var cellViewModel: ViewModel?

    private var cancellable = Set<AnyCancellable>()
    lazy var photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(photoImageView)
        setupConstraints()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with viewModel: PhotoDetailsHeaderViewModel) {
        cellViewModel = viewModel
        if let image = viewModel.image ?? viewModel.bluredImage {
            photoImageView.image = image
        }
        updateToFit(with: viewModel)
        bindToViewModel(viewModel: viewModel)
    }

    private func bindToViewModel(viewModel: PhotoDetailsHeaderViewModel) {
        cancellable.forEach { $0.cancel() }
        viewModel.$image
            .sink { [unowned self] image in
                guard let image else { return }
                photoImageView.image = image
            }
            .store(in: &cancellable)
    }

    private func updateToFit(with viewModel: PhotoDetailsHeaderViewModel) {
        photoImageView.snp.remakeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalTo(photoImageView.snp.width).multipliedBy(viewModel.height / viewModel.width)
        }
    }

    private func setupConstraints() {
        photoImageView.snp.remakeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    static var cellCreator: any CellCreator {
        GenericCellCreator<Self, ViewModel>()
    }
}
