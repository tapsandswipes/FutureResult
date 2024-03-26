import Foundation
import Chainable

public
extension FutureResult where R: Chainable {
    /// Modify the result applying some changes
    /// - Parameter changes: function with the changes to apply
    /// - Returns: a new FutureeResult of the same type
    func modify(_ changes: @escaping (inout R) -> Void) -> Self {
        map { $0.then(changes) }
    }
}
