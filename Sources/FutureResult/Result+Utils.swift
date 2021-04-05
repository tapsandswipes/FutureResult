//
//  Result+Extensions.swift
//  Planout
//
//  Created by Antonio Cabezuelo Vivo on 23/03/2020.
//  Copyright © 2020 Planout Fields SL. All rights reserved.
//

import Foundation


public
extension Result where Success == Void {
    static var void: Self { Self.success(()) }
}

public func void<E>(_ e: E) -> Result<Void, E> { .void }
