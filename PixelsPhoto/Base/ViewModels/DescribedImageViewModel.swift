import Combine
import UIKit.UIImage
import Kingfisher

open class DescribedImageViewModel: BaseCellViewModelImpl {
    var cancellable = Set<AnyCancellable>()
    @Published public var image: UIImage?
    public var imageURL: String? {
        didSet {
            loadImage()
        }
    }

    public var description: String

    public init(description: String, cellCreator: any CellCreator) {
        self.description = description

        super.init(cellCreator: cellCreator)
        loadImage()
    }

    open func loadImage() {
        guard let imageURL,
              let newUrl = URL(string: imageURL) else {
            return
        }
        let resource = Kingfisher.KF.ImageResource(downloadURL: newUrl)

        KingfisherManager.shared.retrieveImage(with: resource) { result in
            switch result {
            case let .success(value):
                self.image = value.image
            case .failure:
                break
            }
        }
    }
}
