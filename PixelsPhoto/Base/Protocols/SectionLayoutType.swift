import UIKit

public protocol SectionLayoutType {
    var layout: NSCollectionLayoutSection { get }
    var title: String? { get }
}
