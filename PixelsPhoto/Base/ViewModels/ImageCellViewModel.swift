import Combine
import UIKit.UIImage
import Kingfisher
import GenericCollection

open class ImageCellViewModel: BaseCellViewModelImpl, ObservableObject {
    @Published public var image: UIImage?
    @Published public var didImageLoading = false
    override public var uuid: String {
        imageURL ?? UUID().uuidString
    }

    public var imageURL: String? {
        didSet {
            loadImage()
        }
    }

    private var imageDownloadTask: DownloadTask?

    override public init(cellCreator: any CellCreator) {
        super.init(cellCreator: cellCreator)
        loadImage()
    }

    open func loadImage() {
        // When user scroling fast prepare for reuse cancels download task.
        // In this case if image not loaded we should start download image again
        guard let imageURL,
              let newUrl = URL(string: imageURL),
              !didImageLoading,
              image == nil else {
            didImageLoading = false
            return
        }
        didImageLoading = true
        let resource = Kingfisher.KF.ImageResource(downloadURL: newUrl)

        imageDownloadTask = KingfisherManager.shared.retrieveImage(with: resource, options: [.cacheMemoryOnly]) { result in
            switch result {
            case let .success(value):
                self.image = value.image
            case .failure:
                self.cancelDownloadTask()
            }
        }
    }

    public func cancelDownloadTask() {
        imageDownloadTask?.cancel()
        imageDownloadTask = nil
    }
}
