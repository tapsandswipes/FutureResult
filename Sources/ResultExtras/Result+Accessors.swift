import Foundation


public
extension Result {
    var value: Success? {
        if case let .success(s) = self {
            return s
        } else {
            return nil
        }
    }
    var error: Failure? {
        if case let .failure(e) = self {
            return e
        } else {
            return nil
        }
    }
}

public
extension Result where Failure == Never {
    var result: Success {
        switch self {
        case .success(let s):
            return s
        }
    }
}

public
extension Result where Success == Never {
    var fail: Failure {
        switch self {
        case .failure(let error):
            return error
        }
    }
}

