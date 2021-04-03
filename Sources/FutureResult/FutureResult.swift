//
//  FutureResult.swift
//  Planout
//
//  Created by Antonio Cabezuelo Vivo on 23/03/2020.
//  Copyright © 2020 Planout Fields SL. All rights reserved.
//

import Foundation


public
typealias Callback<V, E: Error> = (Result<V, E>) -> Void

public
struct FutureResult<R, E: Error> {
    public
    let run: (@escaping Callback<R, E>) -> Void
    
    public
    init(_ run: @escaping (@escaping Callback<R, E>) -> Void) {
        self.run = run
    }
}

public
extension FutureResult {

    init(value: R) {
        self.init {
            $0(.success(value))
        }
    }
    
    init(error: E) {
        self.init {
            $0(.failure(error))
        }
    }

    init(_ result: Result<R, E>) {
        self.init {
            $0(result)
        }
    }
    
    func map<U>(_ f: @escaping (R) -> U) -> FutureResult<U, E> {
        return FutureResult<U, E> { callback in
            self.run {
                callback($0.map(f))
            }
        }
    }
    
    func map<U>(_ f: @escaping (R) -> Result<U, E>) -> FutureResult<U, E> {
        return FutureResult<U, E> { callback in
            self.run {
                callback($0.flatMap(f))
            }
        }
    }
    
    
    func flatMap<U>(_ f: @escaping (R) -> FutureResult<U, E>) -> FutureResult<U, E> {
        return FutureResult<U, E> { callback in
            self.run { r in
                switch r {
                case .success(let v): f(v).run(callback)
                case .failure(let e): callback(.failure(e))
                }
            }
        }
    }
    
    func mapError<U>(_ f: @escaping (E) -> U) -> FutureResult<R, U> {
        return FutureResult<R, U> { callback in
            self.run {
                callback($0.mapError(f))
            }
        }
    }
    
    func mapError<U>(_ f: @escaping (E) -> Result<R, U>) -> FutureResult<R, U> {
        return FutureResult<R, U> { callback in
            self.run {
                callback($0.flatMapError(f))
            }
        }
    }

    func flatMapError<U>(_ f: @escaping (E) -> FutureResult<R, U>) -> FutureResult<R, U> {
        return FutureResult<R, U> { callback in
            self.run { r in
                switch r {
                case .success(let v): callback(.success(v))
                case .failure(let e): f(e).run(callback)
                }
            }
        }
    }
    
    func replaceError(_ f: @escaping (E) -> R) -> FutureResult<R, Never> {
        mapError { .success(f($0)) }
    }
    
    func replaceError(with result: R) -> FutureResult<R, Never> {
        mapError { _ in .success(result) }
    }
    
    func deliver(on queue: DispatchQueue) -> Self {
        Self { callback in
            self.run { r in
                queue.async {
                    callback(r)
                }
            }
        }
    }
    
    func perform(in queue: DispatchQueue) -> Self {
        Self { cb in
            queue.async {
                self.run(cb)
            }
        }
    }
    
    func ignoreOnError() -> FutureResult<R, Never> {
        FutureResult<R, Never> { callback in
            self.run { r in
                if case .success(let v) = r {
                    callback(.success(v))
                }
            }
        }
    }
    
    func replaceResult<U>(with obj: U) -> FutureResult<U, E> {
        map { _ in obj }
    }
    
    func sync(on queue: DispatchQueue? = nil) -> Self {
        FutureResult { cb in
            if let queue = queue {
                queue.async {
                    cb(self.runSync())
                }
            } else {
                cb(self.runSync())
            }
        }
    }
    
    func sync(using semaphore: DispatchSemaphore) -> Self {
        FutureResult { cb in
            waitQueue.async {
                semaphore.wait()
                run {
                    semaphore.signal()
                    cb($0)
                }
            }
        }
    }
    
    func print() -> Self {
        map({ v -> R in Swift.print("RESULT: ", v); return v })
        .printError()
    }

    func printError(prefix: String? = nil) -> Self {
        #if DEBUG
        return mapError({ e -> E in Swift.print( "\(prefix ?? "ERROR"): ", e.localizedDescription); return e })
        #else
        return self
        #endif
    }
    
    func log() -> Self {
        #if DEBUG
        return self.print()
        #else
        return self
        #endif
    }
    
    func print(_ f: @escaping (R) -> String) -> Self {
        map { v -> R in Swift.print(f(v)); return v }
    }
    
    func runSync() -> Result<R, E> {
        var r: Result<R, E>!
        let semaphore = DispatchSemaphore(value: 0)
        waitQueue.async {
            run {
                r = $0
                semaphore.signal()
            }
        }
        semaphore.wait()
        return r
    }
}

private let waitQueue = DispatchQueue(label: "com.planout.future.wait-queue", attributes: .concurrent)

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

extension FutureResult where R == Void {
    static var void: Self { FutureResult(.void) }
    
}

extension FutureResult {
    func toVoid() -> FutureResult<Void, E> {
        map { _ in () }
    }
    
    func toError() -> FutureResult<R, Error> {
        mapError { $0 as Error }
    }
    
    func sleep(_ interval: TimeInterval) -> Self {
        return Self { callback in
            self.run {
                Thread.sleep(forTimeInterval: interval)
                callback($0)
            }
        }
    }
}


func doNothing<T>(_ r: T) { }
func void<E>(_ e: E) -> Result<Void, E> { .void }


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

enum FutureResultError: Error {
    case unwrapFailed
}

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
