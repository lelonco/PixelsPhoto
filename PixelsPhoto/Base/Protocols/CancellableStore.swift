import Combine

public protocol CancellableStore {
    var cancellable: Set<AnyCancellable> { get nonmutating set }
}
