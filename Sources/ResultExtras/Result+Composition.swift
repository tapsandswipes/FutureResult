import Foundation
import FunctionComposition


public
func >>><A, B, C, E>(_ f: @escaping (A) -> Result<B, E>, _ g:  @escaping (B) -> Result<C, E>) -> (A) -> Result<C, E> {
    return { a in f(a).flatMap(g) }
}

public
func zip<A, B, E>(_ r1: Result<A, E>, _ r2: Result<B, E>) -> Result<(A, B), E> {
    switch (r1,r2) {
    case (.failure(let e), _): return .failure(e)
    case (_, .failure(let e)): return .failure(e)
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

public
func zip<A, B, C, D, E>(_ r1: Result<A, E>, _ r2: Result<B, E>, _ r3: Result<C, E>, _ r4: Result<D, E>) -> Result<(A, B, C, D), E> {
    switch (r1,r2,r3,r4) {
    case (.failure(let e), _, _, _): return .failure(e)
    case (_, .failure(let e), _, _): return .failure(e)
    case (_, _, .failure(let e), _): return .failure(e)
    case (_, _, _, .failure(let e)): return .failure(e)
    case (.success(let v1), .success(let v2), .success(let v3), .success(let v4)): return .success((v1, v2, v3, v4))
    }
}
