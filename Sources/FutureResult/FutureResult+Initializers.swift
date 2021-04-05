//
//  File.swift
//  
//
//  Created by Antonio Cabezuelo Vivo on 5/4/21.
//

import Foundation


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
    
    
}
