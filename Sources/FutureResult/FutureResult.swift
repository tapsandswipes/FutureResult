//
//  FutureResult.swift
//  Planout
//
//  Created by Antonio Cabezuelo Vivo on 23/03/2020.
//  Copyright © 2020 Planout Fields SL. All rights reserved.
//

import Foundation


public
struct FutureResult<R, E: Error> {

    public typealias Callback = (Result<R, E>) -> Void

    public let run: (@escaping Callback) -> Void
    
    public
    init(_ run: @escaping (@escaping Callback) -> Void) {
        self.run = run
    }
}
