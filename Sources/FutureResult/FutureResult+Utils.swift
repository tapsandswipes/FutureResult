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

extension FutureResult {
    /// Use the result in a block and continue chain
    /// - Parameter block: the block that will use the result
    /// - Returns: a new future properly configured
    func use(_ block: @escaping (R) -> Void) -> Self {
        map { r -> R in
            block(r)
            return r
        }
    }
}

// We don't use the standard iOS ProgressReporting protocol because it's only defined for NSObject subclasses
public
protocol ProgressReporter {
    var progress: Progress { get }
}

public
struct FutureResultProgress<R, E: Error>: ProgressReporter {
    public let future: FutureResult<R, E>
    public let progress: Progress

    public init(future: FutureResult<R, E>, progress: Progress) {
        self.future = future
        self.progress = progress
    }
}
