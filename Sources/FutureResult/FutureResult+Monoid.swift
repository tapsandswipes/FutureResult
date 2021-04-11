//
//  File.swift
//  
//
//  Created by Antonio Cabezuelo Vivo on 5/4/21.
//

import Foundation


public
extension FutureResult {
    
    /// Return the FutureResult that is the result of applying the function to the .success case of self
    /// - Parameter f: the function to apply
    /// - Returns: the FutureResult returned by the function
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
    
    /// Return the FutureResult that is the result of applying the function to the .failure case of self
    /// - Parameter f: the function to apply
    /// - Returns: the FutureResult returned by the function
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

}
