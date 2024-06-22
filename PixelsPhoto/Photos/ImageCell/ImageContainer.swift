import UIKit
import Combine

class ImageContainer: UIView {
    private var cancellable = Set<AnyCancellable>()
    lazy var imageView: UIImageView = {
        let imgView = UIImageView()
        imgView.contentMode = .scaleAspectFill

        return imgView
    }()

    lazy var backGroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        return view
    }()

    init() {
        super.init(frame: .zero)
        for item in [backGroundView, imageView] {
            addSubview(item)
        }
        setupConstraints()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupConstraints() {
        backGroundView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    func configure(with viewModel: PhotoImageViewModel) {
        imageView.image = viewModel.image
        backGroundView.backgroundColor = UIColor(hex: viewModel.avgColor)
        setupBindings(viewModel: viewModel)
    }

    private func setupBindings(viewModel: PhotoImageViewModel) {
        cancellable.forEach { $0.cancel() }
        viewModel.$image
            .sink { [unowned self] image in
                guard let image else { return }
                imageView.image = image
            }
            .store(in: &cancellable)
    }
}
