import UIKit
import GenericCollection

class PhotoDetailsInfoViewModel: BaseCellViewModelImpl {

    private let photo: Photo
    var photographer: String
    var photoId: Int
    var photoAltName: String
    var avgColor: String
    var width: Int
    var height: Int
    init(photo: Photo, cellCreator: any CellCreator) {
        self.photo = photo
        photographer = photo.photographer
        photoId = photo.id
        photoAltName = photo.alt
        avgColor = photo.avgColor
        width = photo.width
        height = photo.height
        super.init(cellCreator: cellCreator)
    }
}
