import UIKit

class PhotoDetailsCoordinator: Coordinator {
    let uuid: String
    var navigationController: UINavigationController
    var childs: [any Coordinator] = []
    weak var parrent: (any Coordinator)?

    private var viewModel: PhotoDetailsViewModel?
    private let photo: PhotoImageViewModel

    init(navigationController: UINavigationController, photo: PhotoImageViewModel, parrent: Coordinator) {
        uuid = UUID().uuidString
        self.parrent = parrent
        self.photo = photo
        self.navigationController = navigationController
    }

    @discardableResult
    func start(animated: Bool) -> UIViewController {
        let viewModel = PhotoDetailsViewModel(photo: photo.model, page: photo.page, preloadedPhoto: photo.image, coordinator: self)
        self.viewModel = viewModel
        let vc = PhotoDetailsViewController(viewModel: viewModel)
        navigationController.pushViewController(vc, animated: true)
        return vc
    }

    func openDetails(for photo: PhotoImageViewModel) {
        let coordinator = PhotoDetailsCoordinator(navigationController: navigationController, photo: photo, parrent: self)
        coordinator.start(animated: true)
        childs.append(coordinator)
    }

    func didDisappear() {
        childs.isEmpty ? finish() : ()
    }

    func finish() {
        childs.forEach { $0.finish() }
        parrent?.childDidFinish(self)
    }
}
