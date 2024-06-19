import Foundation
import GenericCollection

class PhotoImageViewModel: ImageCellViewModel {

    override var uuid: String {
        model.id.description
    }

    let page: PexelsResponse
    let model: Photo
    public var authorName: String
    public var altName: String
    public var avgColor: String
    init(model: Photo, relatesTo: PexelsResponse, cellCreator: any CellCreator) {
        self.model = model
        authorName = model.photographer
        altName = model.alt
        avgColor = model.avgColor
        page = relatesTo
        super.init(cellCreator: cellCreator)
        imageURL = model.src.portrait
    }
}
