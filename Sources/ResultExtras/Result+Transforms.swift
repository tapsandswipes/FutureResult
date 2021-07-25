//
//  File.swift
//  
//
//  Created by Antonio Cabezuelo Vivo on 5/4/21.
//

import Foundation


public
extension Result {

    func toVoid() -> Result<Void, Failure> {
        map { _ in () }
    }
    
    func toError() -> Result<Success, Error> {
        mapError { $0 as Error }
    }

    func replaceError(_ f: (Failure) -> Success ) -> Result<Success, Never> {
        return self.flatMapError { .success(f($0)) }
    }
    
    func replaceError(with v: Success) -> Result<Success, Never> {
        return self.flatMapError { _ in .success(v) }
    }
    
    func replaceResult<U>(with obj: U) -> Result<U, Failure> {
        map { _ in obj }
    }

}

