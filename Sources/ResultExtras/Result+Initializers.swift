//
//  File.swift
//  
//
//  Created by Antonio Cabezuelo Vivo on 28/5/21.
//

import Foundation


public
extension Result {
    init(unwrapping optional: Success?, error: Failure) {
        if let v = optional {
            self = .success(v)
        } else {
            self = .failure(error)
        }
    }
}
