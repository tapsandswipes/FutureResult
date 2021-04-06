//
//  File.swift
//  
//
//  Created by Antonio Cabezuelo Vivo on 3/4/21.
//

import Foundation
import Chainable

extension Result: Chainable {}

public
extension Result where Success: Chainable {
    func modify(_ changes: @escaping (inout Success) -> Void ) -> Self {
        map { $0.then(changes) }
    }
}

