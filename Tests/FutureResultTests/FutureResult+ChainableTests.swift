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
            do {
                let v = try XCTUnwrap($0.value)
                XCTAssertEqual(v, r)
            } catch {
                XCTFail()
            }
        }
        
        sut.modify { $0.name = "Changed" }.run {
            do {
                let v = try XCTUnwrap($0.value)
                XCTAssertEqual(v.name, "Changed")
                XCTAssertEqual(v.count, r.count)
            } catch {
                XCTFail()
            }
        }
    }
    
}

struct ChainableStruct: Chainable, Hashable {
    var name: String
    var count: Int
}
