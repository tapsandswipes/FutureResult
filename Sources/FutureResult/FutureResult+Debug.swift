//
//  File.swift
//  
//
//  Created by Antonio Cabezuelo Vivo on 5/4/21.
//

import Foundation

public
extension FutureResult {
    
    func print() -> Self {
        .printValue()
        .printError()
    }
    
    func printValue(prefix: String? = nil) -> Self {
        #if DEBUG
        return map { v -> R in Swift.print("\(prefix ?? "RESULT"): ", v); return v }
        #else
        return self
        #endif
    }
    
    func printError(prefix: String? = nil) -> Self {
        #if DEBUG
        return mapError { e -> E in Swift.print("\(prefix ?? "ERROR"): ", e.localizedDescription); return e }
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

}
