//
//  File.swift
//  
//
//  Created by Antonio Cabezuelo Vivo on 3/4/21.
//

import Foundation
import Chainable

extension FutureResult where R: Chainable {
    func apply(_ changes: @escaping (inout R) -> Void) -> Self {
        map { $0.then(changes) }
    }
}

extension FutureResult where R: Chainable {
    func modify(_ f: @escaping (inout R) -> Void ) -> Self {
        return Self { callback in
            self.run {
                callback($0.modify(f))
            }
        }
    }
}
