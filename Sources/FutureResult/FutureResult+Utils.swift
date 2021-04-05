//
//  File.swift
//  
//
//  Created by Antonio Cabezuelo Vivo on 5/4/21.
//

import Foundation


public
extension FutureResult where R == Void {
    static var void: Self { FutureResult(.void) }
}

public func void<E>(_ e: E) -> FutureResult<Void, E> { .void }


public
enum FutureResultError: Error {
    case unwrapFailed
}

public
extension FutureResult where R == Optional<Any> {
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
