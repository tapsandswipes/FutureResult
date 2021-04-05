//
//  File.swift
//  
//
//  Created by Antonio Cabezuelo Vivo on 5/4/21.
//

import Foundation


public
extension FutureResult {
    
    func toVoid() -> FutureResult<Void, E> {
        map { _ in () }
    }
    
    func toError() -> FutureResult<R, Error> {
        mapError { $0 as Error }
    }

    func replaceError(_ f: @escaping (E) -> R) -> FutureResult<R, Never> {
        mapError { .success(f($0)) }
    }
    
    func replaceError(with result: R) -> FutureResult<R, Never> {
        mapError { _ in .success(result) }
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
    
}
