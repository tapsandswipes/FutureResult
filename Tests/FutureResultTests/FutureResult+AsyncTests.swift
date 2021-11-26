//
//  FutureResultAsync.swift
//  
//
//  Created by Antonio Cabezuelo Vivo on 9/11/21.
//

import XCTest
@testable import FutureResult


class FutureResultAsync: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    @available(iOS 13.0, *)
    func testRunOK() async throws {
        let sut = FutureResult<Bool, Error> {
            $0(.success(true))
        }

        let r = try await sut.run()
        
        XCTAssertTrue(r)
    }

    @available(iOS 13.0, *)
    func testFutureRunKO() async throws {
        let sut = FutureResult<Bool, TestError> {
            $0(.failure(TestError.error))
        }
        
        do {
            let _ = try await sut.run()
            XCTFail("sut run must fail")
        } catch {
            XCTAssert(error is TestError)
        }
    }

    @available(iOS 13.0, *)
    func testRunOK2() async throws {
        let sut = FutureResult<Bool, Never> {
            $0(.success(true))
        }
        
        let r = await sut.run()
        
        XCTAssertTrue(r)
    }

    
    @available(iOS 13.0, *)
    func testRunOK3() async throws {
        let sut = FutureResult<Void, Never> {
            $0(.void)
        }
        
        await sut.run()
    }
    
    @available(iOS 13.0, *)
    func testFutureRunKO2() async throws {
        let sut = FutureResult<Void, TestError> {
            $0(.failure(TestError.error))
        }
        
        do {
            try await sut.run()
            XCTFail("sut run must fail")
        } catch {
            XCTAssert(error is TestError)
        }
    }

}
