//
//  Result+Extensions.swift
//  Planout
//
//  Created by Antonio Cabezuelo Vivo on 23/03/2020.
//  Copyright © 2020 Planout Fields SL. All rights reserved.
//

import Foundation

infix operator >=> : FunctionCompositionGroup

public
func >=><A, B, C, E>(_ f: @escaping (A) -> Result<B, E>, _ g:  @escaping (B) -> Result<C, E>) -> (A) -> Result<C, E> {
    return { a in f(a).flatMap(g) }
}

public
func zip<A, B, E>(_ r1: Result<A, E>, _ r2: Result<B, E>) -> Result<(A, B), E> {
    switch (r1,r2) {
    case (_, .failure(let e)): return .failure(e)
    case (.failure(let e), _): return .failure(e)
    case (.success(let v1), .success(let v2)): return .success((v1, v2))
    }
}

public
func zip<A, B, C, E>(_ r1: Result<A, E>, _ r2: Result<B, E>, _ r3: Result<C, E>) -> Result<(A, B, C), E> {
    switch (r1,r2,r3) {
    case (.failure(let e), _, _): return .failure(e)
    case (_, .failure(let e), _): return .failure(e)
    case (_, _, .failure(let e)): return .failure(e)
    case (.success(let v1), .success(let v2), .success(let v3)): return .success((v1, v2, v3))
    }
}

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
    
    func replaceError(_ f: (Failure) -> Success ) -> Result<Success, Never> {
        return self.flatMapError({ .success(f($0)) })
    }
    
    func replaceError(with v: Success) -> Result<Success, Never> {
        return self.flatMapError { _ in .success(v) }
    }
}

extension Result where Failure == Never {
    var result: Success {
        switch self {
        case .success(let s):
            return s
        }
    }
}

extension Result where Success == Never {
    var fail: Failure {
        switch self {
        case .failure(let error):
            return error
        }
    }
}

extension Result where Success == Void {
    static var void: Self { Self.success(()) }
}

extension Result {
    func toVoid() -> Result<Void, Failure> {
        map({ _ in () })
    }
    
    func toError() -> Result<Success, Error> {
        mapError({ $0 as Error })
    }
}

