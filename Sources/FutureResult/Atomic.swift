//
//  Atomic.swift
//  Planout
//
//  Created by Antonio Cabezuelo Vivo on 25/06/2020.
//  Copyright © 2020 Planout Fields SL. All rights reserved.
//

import Foundation

final class Atomic<A> {
    private let queue = DispatchQueue(label: "Atomic serial queue")
    private var _value: A
    init(_ value: A) {
        self._value = value
    }
    
    var value: A {
        get {
            return queue.sync { self._value }
        }
    }
    
    func mutate(_ transform: (inout A) -> ()) {
        queue.sync {
            transform(&self._value)
        }
    }
}
