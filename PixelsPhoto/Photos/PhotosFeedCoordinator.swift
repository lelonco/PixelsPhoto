import UIKit

class PhotosFeedCoordinator: NSObject, Coordinator {
    let uuid: String

    var navigationController: UINavigationController

    var childs: [any Coordinator] = []
    private var viewModel: PhotosFeedViewModel?
    weak var parrent: (any Coordinator)?

    init(navigationController: UINavigationController, parrent: Coordinator) {
        uuid = UUID().uuidString
        self.parrent = parrent
        self.navigationController = navigationController
    }

    @discardableResult
    func start(animated: Bool) -> UIViewController {
        let viewModel = PhotosFeedViewModel(networkService: PhotosService())
        self.viewModel = viewModel
        viewModel.coordinator = self
        let vc = PhotosFeedViewController(viewModel: viewModel)

        navigationController.setViewControllers([vc], animated: animated)
        navigationController.delegate = self
        return vc
    }

    func openDetails(for photo: PhotoImageViewModel) {
        let coordinator = PhotoDetailsCoordinator(navigationController: navigationController, photo: photo, parrent: self)
        coordinator.start(animated: true)
        childs.append(coordinator)
    }

    func finish() {
        // Shouldn't finish
    }
}

extension PhotosFeedCoordinator: UINavigationControllerDelegate {

    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {

        guard viewController is PhotosFeedViewController,
              !childs.isEmpty else { return }
        // Looks like we jumped back from details to root
        childs.forEach { $0.finish() }
    }
}
