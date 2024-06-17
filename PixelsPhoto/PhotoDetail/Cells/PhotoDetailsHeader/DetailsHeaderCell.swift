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
        if let image = viewModel.bluredImage {
            photoImageView.image = image
        }
        bindToViewModel(viewModel: viewModel)
    }

    private func bindToViewModel(viewModel: PhotoDetailsHeaderViewModel) {
        viewModel.$image
            .sink { [unowned self] image in
                guard let image else { return }
                photoImageView.image = image
            }
            .store(in: &cancellable)
    }

    private func setupConstraints() {
        // Add constraints
        photoImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    static var cellCreator: any CellCreator {
        GenericCellCreator<Self, ViewModel>()
    }
}
