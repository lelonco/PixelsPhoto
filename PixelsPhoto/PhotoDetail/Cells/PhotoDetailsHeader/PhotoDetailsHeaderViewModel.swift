import UIKit
import GenericCollection

class PhotoDetailsHeaderViewModel: ImageCellViewModel {

    private let photo: Photo
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
        let inputImage = CIImage(image: image)

        let filter = CIFilter(name: "CIGaussianBlur")
        filter?.setValue(inputImage, forKey: kCIInputImageKey)
        filter?.setValue(10, forKey: kCIInputRadiusKey)

        guard let outputImage = filter?.outputImage else {
            bluredImage = image
            return
        }

        if let cgImage = context.createCGImage(outputImage, from: outputImage.extent) {
            bluredImage = UIImage(cgImage: cgImage)
        }

        bluredImage = image
    }

    private func setupData() {
        imageURL = photo.src.large
    }
}
