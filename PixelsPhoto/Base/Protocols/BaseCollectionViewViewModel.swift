import Combine
import UIKit

public protocol BaseCollectionViewViewModel: CancellableStore, ObservableObject {
    var sectionPublisher: AnyPublisher<[SectionViewModel], Never> { get }

    func layoutType(for indexPath: IndexPath) -> NSCollectionLayoutSection?

    func willDisplayCell(with indexPath: IndexPath)

    func didSelect(at indexPath: IndexPath)
}
