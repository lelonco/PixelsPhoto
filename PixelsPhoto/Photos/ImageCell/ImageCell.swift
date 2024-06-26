import UIKit
import Combine
import GenericCollection

class ImageCell: UICollectionViewCell, ConfigurableCell {
    typealias ViewModel = PhotoImageViewModel
    private var cancellable = Set<AnyCancellable>()
    var cellViewModel: ViewModel?
    private lazy var photoImageView: ImageContainer = {
        let imgView = ImageContainer()
        imgView.layer.cornerRadius = 8
        imgView.layer.cornerCurve = .continuous
        imgView.layer.masksToBounds = true

        return imgView
    }()

    private lazy var wrapedImage: UIView = {
        let view = UIView()
        view.addSubview(photoImageView)
        view.layer.shadowOffset = .init(width: 0, height: 4)
        view.layer.shadowOpacity = 0.2
        view.layer.shadowRadius = 4
        view.layer.shadowColor = UIColor.black.cgColor
        return view
    }()

    private lazy var altName: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 16)

        return label
    }()

    private lazy var author: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 12, weight: .light)

        return label
    }()

    private lazy var texts: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [altName, author])
        stack.spacing = 4
        stack.axis = .vertical

        return stack
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        for item in [wrapedImage, texts] {
            contentView.addSubview(item)
        }
        setupConstraints()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        cellViewModel?.cancelDownloadTask()
    }

    func configure(with viewModel: ViewModel) {
        photoImageView.configure(with: viewModel)
        altName.text = viewModel.altName
        author.text = viewModel.authorName

        altName.isHidden = viewModel.altName.isEmpty
        author.isHidden = viewModel.authorName.isEmpty
    }

    private func setupConstraints() {
        photoImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        wrapedImage.snp.makeConstraints { make in
            make.width.top.centerX.equalToSuperview()
            make.height.equalTo(photoImageView.snp.width).dividedBy(0.66666)
        }

        texts.snp.makeConstraints { make in
            make.top.equalTo(photoImageView.snp.bottom).offset(4)
            make.horizontalEdges.bottom.equalToSuperview()
        }
    }

    static var cellCreator: any CellCreator {
        GenericCellCreator<Self, ViewModel>()
    }
}
