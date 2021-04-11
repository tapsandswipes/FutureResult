//
//  File.swift
//  
//
//  Created by Antonio Cabezuelo Vivo on 5/4/21.
//

import Foundation


public
extension FutureResult {
    
    /// Generate a new FutureResult that will apply the function to the .success case of the result
    /// - Parameter f: function to apply to the
    /// - Returns: A new FutureResult
    func map<U>(_ f: @escaping (R) -> U) -> FutureResult<U, E> {
        return FutureResult<U, E> { callback in
            self.run {
                callback($0.map(f))
            }
        }
    }
    
    /// Generate a new FutureResult that will apply the function to the .success case of the result
    /// - Parameter f: function to apply to the
    /// - Returns: A new FutureResult
    func map<U>(_ f: @escaping (R) -> Result<U, E>) -> FutureResult<U, E> {
        return FutureResult<U, E> { callback in
            self.run {
                callback($0.flatMap(f))
            }
        }
    }
    
    /// Generate a new FutureResult that will apply the function to the .failure case of the result
    /// - Parameter f: function to apply to the
    /// - Returns: A new FutureResult
    func mapError<U>(_ f: @escaping (E) -> U) -> FutureResult<R, U> {
        return FutureResult<R, U> { callback in
            self.run {
                callback($0.mapError(f))
            }
        }
    }
    
    /// Generate a new FutureResult that will apply the function to the .failure case of the result
    /// - Parameter f: function to apply to the
    /// - Returns: A new FutureResult
    func mapError<U>(_ f: @escaping (E) -> Result<R, U>) -> FutureResult<R, U> {
        return FutureResult<R, U> { callback in
            self.run {
                callback($0.flatMapError(f))
            }
        }
    }
    
}
