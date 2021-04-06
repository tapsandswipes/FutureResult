//
//  File.swift
//  
//
//  Created by Antonio Cabezuelo Vivo on 5/4/21.
//

import Foundation

public
extension FutureResult where R: Sequence {
    func flatFlatMap<U>(_ f: @escaping (R.Element) -> FutureResult<U, E>) -> FutureResult<Array<Result<U, E>>, Never> {
        flatMap { r in
            FutureResult<[Result<U, E>], E> { cb in
                let results: Atomic<[Result<U, E>]> = Atomic([])
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
        }.ignoreOnError()
    }
}


public
func >=><A, B, C, E>(_ f: @escaping (A) -> FutureResult<B, E>, _ g:  @escaping (B) -> FutureResult<C, E>) -> (A) -> FutureResult<C, E> {
    return { f($0).flatMap(g) }
}

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
