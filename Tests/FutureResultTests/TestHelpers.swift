//
//  TestHelpers.swift
//  PlanoutTests
//
//  Created by Antonio Cabezuelo Vivo on 30/06/2020.
//  Copyright © 2020 Planout Fields SL. All rights reserved.
//

import Foundation
import XCTest
@testable import FutureResult


extension FutureResult {
    func assertTrue(file: StaticString = #filePath, line: UInt = #line, _ f: @escaping (R) -> Bool, _ message: ((R) -> String)? = nil) -> Self {
        map { r -> R in
            XCTAssertTrue(f(r), message?(r) ?? "", file: file, line: line)
            return r
        }
        .mapError { error -> E in
            XCTFail(error.localizedDescription, file: file, line: line)
            return error
        }
    }
    
    func assertNoError(file: StaticString = #filePath, line: UInt = #line) -> Self {
        mapError { error -> E in
            XCTFail(error.localizedDescription, file: file, line: line)
            return error
        }
    }
    
}

extension Result {
    func check(file: StaticString = #filePath, line: UInt = #line, _ block: @escaping (Success) -> Void) {
        do {
            let v = try XCTUnwrap(self.value)
            block(v)
        } catch {
            XCTFail(error.localizedDescription, file: file, line: line)
        }
    }
}
