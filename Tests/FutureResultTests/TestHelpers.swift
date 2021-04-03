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
    func assert(file: StaticString = #filePath, line: UInt = #line, _ f: @escaping (R) -> Bool, _ message: ((R) -> String)? = nil) -> Self {
        return Self { callback in
            self.run {
                switch $0 {
                case .success(let r):
                    XCTAssertTrue(f(r), message?(r) ?? "", file: file, line: line)
                case .failure(let error):
                    XCTFail(error.localizedDescription, file: file, line: line)
                }
                callback($0)
            }
        }
    }
    
    func assertNoError(file: StaticString = #filePath, line: UInt = #line) -> Self {
        return Self { callback in
            self.run {
                if case .failure(let error) = $0 {
                    XCTFail(error.localizedDescription, file: file, line: line)
                }
                callback($0)
            }
        }
    }
}
