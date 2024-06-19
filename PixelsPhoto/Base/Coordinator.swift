import UIKit

protocol Coordinator: AnyObject {
    var uuid: String { get }
    var navigationController: UINavigationController { get set }
    var childs: [Coordinator] { get set }
    /// Should be weak
    var parrent: Coordinator? { get set }
    func start(animated: Bool) -> UIViewController
    func finish()
    func childDidFinish(_ child: Coordinator)
}

extension Coordinator {
    func childDidFinish(_ child: Coordinator) {
        childs.removeAll { coordinator in
            coordinator.uuid == child.uuid
        }
    }
}
