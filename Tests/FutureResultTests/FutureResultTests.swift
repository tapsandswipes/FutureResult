import XCTest
@testable import FutureResult

final class FutureResultTests: XCTestCase {
    func testFutureRunOK() {

        let sut = FutureResult<Bool, Error> {
            $0(.success(true))
        }
        
        sut.run {
            XCTAssertNotNil($0.value)
            XCTAssert($0.value == .some(true))
        }
        
    }

    func testFutureRunKO() {
        let sut = FutureResult<Bool, TestError> {
            $0(.failure(TestError.error))
        }
        
        sut.run {
            XCTAssertNotNil($0.error)
            XCTAssert($0.error == .some(TestError.error))
        }
        
    }

}

enum TestError: Error, Equatable {
    case error
}
