//
//  Result+Extensions.swift
//  Planout
//
//  Created by Antonio Cabezuelo Vivo on 23/03/2020.
//  Copyright © 2020 Planout Fields SL. All rights reserved.
//

import Foundation


public
extension Result where Success == Void {
    static var void: Self { Self.success(()) }
}

public func void<E>(_ e: E) -> Result<Void, E> { .void }

public
enum ResultError: Error {
    case unwrapFailed
}

public
extension Optional {
    func asResult() -> Result<Wrapped, Error> {
        Result(unwrapping: self, error: ResultError.unwrapFailed)
    }
}

public
extension Result where Success == Optional<Any> {
    /// Unwrap an optional result to its wrapped value
    /// - Returns: a new result with the urwrapped value
    func unwrap<U>() -> Result<U, Error> {
        self.toError().flatMap {
            if case .some(let c) = $0, let u = c as? U {
                return .success(u)
            } else {
                return .failure(ResultError.unwrapFailed)
            }
        }
    }
}
