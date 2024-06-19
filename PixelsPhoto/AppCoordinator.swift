import UIKit

class AppCoordinator: Coordinator {
    let uuid: String
    var navigationController: UINavigationController

    var childs: [any Coordinator] = []

    var parrent: (any Coordinator)?

    init(navigationController: UINavigationController) {
        uuid = UUID().uuidString
        self.navigationController = navigationController
    }

    @discardableResult
    func start(animated: Bool) -> UIViewController {
        let feedCoordinator = PhotosFeedCoordinator(navigationController: navigationController, parrent: self)
        childs.append(feedCoordinator)
        feedCoordinator.start(animated: true)
        return navigationController
    }

    func finish() {
        // Shouldn't finish
    }
}
