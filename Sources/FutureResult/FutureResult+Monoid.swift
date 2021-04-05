//
//  File.swift
//  
//
//  Created by Antonio Cabezuelo Vivo on 5/4/21.
//

import Foundation


public
extension FutureResult {

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
