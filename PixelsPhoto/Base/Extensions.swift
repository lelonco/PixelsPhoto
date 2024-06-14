import Foundation

extension MutableCollection {
    subscript(safe index: Index) -> Element? {
        get {
            indices.contains(index) ? self[index] : nil
        }

        set(newValue) {
            if let newValue, indices.contains(index) {
                self[index] = newValue
            }
        }
    }
}
