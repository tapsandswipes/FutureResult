//
//  File.swift
//  
//
//  Created by Antonio Cabezuelo Vivo on 3/4/21.
//

import Foundation
import Chainable

public
extension FutureResult where R: Chainable {
    func apply(_ changes: @escaping (inout R) -> Void) -> Self {
        map { $0.then(changes) }
    }
}
