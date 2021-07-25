//
//  File.swift
//  
//
//  Created by Antonio Cabezuelo Vivo on 5/4/21.
//

import Foundation


public
extension FutureResult where R == Void {
    /// Shortcut to create Void futures
    static var void: Self { FutureResult(.void) }
}

/// Shortcut to create futures of type `FutureResult<Void, Error>`
/// - Parameter e: the error to use
/// - Returns: future instance
public func void<E>() -> FutureResult<Void, E> { .void }


public
enum FutureResultError: Error {
    case unwrapFailed
}

public
extension FutureResult where R == Optional<Any> {
    /// Unwrap an optional result to its wrapped value
    /// - Returns: a new future properly configured
    func unwrap<U>() -> FutureResult<U, Error> {
        self.toError().map {
            if case .some(let c) = $0, let u = c as? U {
                return .success(u)
            } else {
                return .failure(FutureResultError.unwrapFailed)
            }
        }
    }
}
