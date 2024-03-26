import Foundation


public
extension Result {
    init(unwrapping optional: Success?, error: Failure) {
        if let v = optional {
            self = .success(v)
        } else {
            self = .failure(error)
        }
    }
}
