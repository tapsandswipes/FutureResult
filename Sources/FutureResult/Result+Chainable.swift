//
//  File.swift
//  
//
//  Created by Antonio Cabezuelo Vivo on 3/4/21.
//

import Foundation
import Chainable


extension Result where Success: Chainable {
    func modify(_ f: @escaping (inout Success) -> Void ) -> Self {
        switch self {
        case .success(let r):
            return .success(r.then(f))
        case .failure:
            return self
        }
    }
}

extension Result : Chainable {}
