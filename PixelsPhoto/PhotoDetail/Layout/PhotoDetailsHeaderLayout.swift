import UIKit

final class PhotoDetailsHeaderLayout: NSCollectionLayoutSection {
    convenience init() {
        let item = NSCollectionLayoutItem(layoutSize: Sizes.itemSize)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: Sizes.groupSize, subitems: [item])
        self.init(group: group)
        orthogonalScrollingBehavior = .none
        contentInsets = Sizes.sectionInsets
    }
}

private extension PhotoDetailsHeaderLayout {
    enum Sizes {
        /// Items size is ignored because we set items count
        static let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                     heightDimension: .estimated(198))

        static var groupSize: NSCollectionLayoutSize {
            if UIDevice.isPad {
                NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                       heightDimension: .estimated(198))
            } else {
                NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                       heightDimension: .estimated(198))
            }
        }

        static let sectionInsets = NSDirectionalEdgeInsets(top: 0, leading: 24, bottom: 8, trailing: 24)
    }
}
