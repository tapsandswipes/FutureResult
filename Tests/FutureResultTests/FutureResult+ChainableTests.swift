import XCTest
@testable import FutureResult
import Chainable

final class FutureResultChainableTests: XCTestCase {
    func testModify() throws {
        let r = ChainableStruct(name: "Hi", count: 2)
        
        let sut = FutureResult<ChainableStruct, Error> {
            $0(.success(r))
        }
        
        sut.run {
            $0.check {
                XCTAssertEqual($0, r)
            }
        }
        
        sut.modify { $0.name = "Changed" }.run {
            $0.check {
                XCTAssertEqual($0.name, "Changed")
                XCTAssertEqual($0.count, r.count)
            }
        }
    }
    
}

struct ChainableStruct: Chainable, Hashable {
    var name: String
    var count: Int
}
