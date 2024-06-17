import Foundation
import GenericCollection

class PhotoImageViewModel: ImageCellViewModel {

    override var uuid: String {
        model.id.description
    }

    private let model: Photo
    public var authorName: String
    public var altName: String
    init(model: Photo, cellCreator: any CellCreator) {
        self.model = model
        authorName = model.photographer
        altName = model.alt
        super.init(cellCreator: cellCreator)
        imageURL = model.src.portrait
    }
}
