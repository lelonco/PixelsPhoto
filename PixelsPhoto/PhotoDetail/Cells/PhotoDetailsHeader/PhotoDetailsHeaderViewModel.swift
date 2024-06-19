import UIKit
import GenericCollection

protocol PhotoDetailsHeaderDelegate: AnyObject {
    func didUpdatedConstraints()
}

class PhotoDetailsHeaderViewModel: ImageCellViewModel {
    weak var delegate: PhotoDetailsHeaderDelegate?
    private let photo: Photo
    var width: Double { Double(photo.width) }
    var height: Double { Double(photo.height) }
    var bluredImage: UIImage?
    init(photo: Photo, image: UIImage?, cellCreator: any CellCreator) {
        self.photo = photo
        super.init(cellCreator: cellCreator)
        addBlureTo(image: image)
        setupData()
    }

    private func addBlureTo(image: UIImage?) {
        guard let image else { return }

        let context = CIContext(options: nil)

        guard let currentFilter = CIFilter(name: "CIGaussianBlur"),
              let beginImage = CIImage(image: image) else { return }

        currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
        currentFilter.setValue(10, forKey: kCIInputRadiusKey)

        guard let cropFilter = CIFilter(name: "CICrop") else { return }
        cropFilter.setValue(currentFilter.outputImage, forKey: kCIInputImageKey)
        cropFilter.setValue(CIVector(cgRect: beginImage.extent), forKey: "inputRectangle")

        let output = cropFilter.outputImage
        let cgimg = context.createCGImage(output!, from: output!.extent)
        let processedImage = UIImage(cgImage: cgimg!)
        bluredImage = processedImage
    }

    func didUpdatedConstraints() {
        delegate?.didUpdatedConstraints()
    }

    private func setupData() {
        imageURL = photo.src.original
    }
}
