import UIKit

extension UIDevice {
    static var isPad: Bool {
        current.userInterfaceIdiom == .pad
    }
}

enum FeedSectionSizes {
    static var spacing: CGFloat {
        UIDevice.isPad && UIDevice.current.orientation.isLandscape ? 16 : 8
    }

    static var sectionInsets: NSDirectionalEdgeInsets {
        if UIDevice.isPad {
            let bottom: CGFloat = UIDevice.current.orientation.isLandscape ? 32 : 24
            let hInsets: CGFloat = UIDevice.current.orientation.isLandscape ? 40 : 52
            return NSDirectionalEdgeInsets(top: 8, leading: hInsets, bottom: bottom, trailing: hInsets)

        } else {
            return NSDirectionalEdgeInsets(top: 8, leading: 24, bottom: 32, trailing: 23)
        }
    }

    static var untiWidth: CGFloat {
        UIDevice.isPad ? 0.14 : 0.277
    }
}

final class PhotoFeedLayout: NSCollectionLayoutSection {
    convenience init() {
        let item = NSCollectionLayoutItem(layoutSize: Sizes.itemSize)

        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: Sizes.groupSize,
            subitem: item,
            count: Sizes.count
        )
        group.interItemSpacing = .fixed(8)
        self.init(group: group)
        orthogonalScrollingBehavior = .none
        contentInsets = Sizes.sectionInsets
        interGroupSpacing = 8
    }
}

private extension PhotoFeedLayout {
    enum Sizes {
        static var count: Int {
            if UIDevice.isPad {
                6
            } else {
                3
            }
        }

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
