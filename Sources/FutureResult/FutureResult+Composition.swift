//
//  File.swift
//  
//
//  Created by Antonio Cabezuelo Vivo on 5/4/21.
//

import Foundation
import FunctionComposition
import ResultExtras

public
extension FutureResult where R: Sequence {
    /// Apply a function on every element of the sequence and return the concatenation of the resulting values
    /// - Parameter f: function to apply
    /// - Returns: A new FutureResult with an array of results
    func flatFlatMap<U, UE>(_ f: @escaping (R.Element) -> FutureResult<U, UE>) -> FutureResult<Array<Result<U, UE>>, E> {
        flatMap { r in
            FutureResult<[Result<U, UE>], E> { cb in
                let results: Atomic<[Result<U, UE>]> = Atomic([])
                let group = DispatchGroup()
                r.forEach {
                    group.enter()
                    f($0).run { e in
                        results.mutate { $0.append(e) }
                        group.leave()
                    }
                }
                
                group.notify(queue: .global()) {
                    cb(.success(results.value))
                }
            }
        }
    }
}


public
func >>><A, B, C, E>(_ f: @escaping (A) -> FutureResult<B, E>, _ g:  @escaping (B) -> FutureResult<C, E>) -> (A) -> FutureResult<C, E> {
    return { f($0).flatMap(g) }
}

/// Run 2 futures in parallel and return the tuple with the result of each future. Both futures must have the smae kind of error
/// - Parameters:
///   - f1: first future in the tuple
///   - f2: second future in the tuple
/// - Returns: A new future with the tuple
public
func zip<A, B, E>(_ f1: FutureResult<A, E>, _ f2: FutureResult<B, E>) -> FutureResult<(A,B), E> {
    return FutureResult<(A,B), E> { callback in
        var f1r: Result<A, E>!
        var f2r: Result<B, E>!
        
        let group = DispatchGroup()
        
        group.enter(); f1.run { f1r = $0; group.leave() }
        group.enter(); f2.run { f2r = $0; group.leave() }
        
        group.notify(queue: .main, execute: { callback(zip(f1r, f2r)) })
    }
}

/// Run 3 futures in parallel and return the tuple with the result of each future. All futures must have the smae kind of error
/// - Parameters:
///   - f1: first future in the tuple
///   - f2: second future in the tuple
///   - f3: third future in the tuple
/// - Returns: A new future with the tuple
public
func zip<A, B, C, E>(_ f1: FutureResult<A, E>, _ f2: FutureResult<B, E>, _ f3: FutureResult<C, E>) -> FutureResult<(A,B,C), E> {
    return FutureResult<(A,B,C), E> { callback in
        var f1r: Result<A, E>!
        var f2r: Result<B, E>!
        var f3r: Result<C, E>!
        
        let group = DispatchGroup()
        
        group.enter(); f1.run { f1r = $0; group.leave() }
        group.enter(); f2.run { f2r = $0; group.leave() }
        group.enter(); f3.run { f3r = $0; group.leave() }
        
        group.notify(queue: .main, execute: { callback(zip(f1r, f2r, f3r)) })
    }
}

/// Run 4 futures in parallel and return the tuple with the result of each future. All futures must have the smae kind of error
/// - Parameters:
///   - f1: first future in the tuple
///   - f2: second future in the tuple
///   - f3: third future in the tuple
///   - f4: fourth future in the tuple
/// - Returns: A new future with the tuple
public
func zip<A, B, C, D, E>(_ f1: FutureResult<A, E>, _ f2: FutureResult<B, E>, _ f3: FutureResult<C, E>, _ f4: FutureResult<D, E>) -> FutureResult<(A,B,C,D), E> {
    return FutureResult<(A,B,C,D), E> { callback in
        var f1r: Result<A, E>!
        var f2r: Result<B, E>!
        var f3r: Result<C, E>!
        var f4r: Result<D, E>!

        let group = DispatchGroup()
        
        group.enter(); f1.run { f1r = $0; group.leave() }
        group.enter(); f2.run { f2r = $0; group.leave() }
        group.enter(); f3.run { f3r = $0; group.leave() }
        group.enter(); f4.run { f4r = $0; group.leave() }

        group.notify(queue: .main, execute: { callback(zip(f1r, f2r, f3r, f4r)) })
    }
}
