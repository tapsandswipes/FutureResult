import XCTest
@testable import FunctionComposition


final class FunctionCompositionTests: XCTestCase {
    
    func testID() throws {
        var sut = id(true)
        
        XCTAssertTrue(sut)
        
        sut = id(false)
        
        XCTAssertFalse(sut)
    }
    
    func testCastOK() throws {
        let s: Any = "Hi"
        
        let sut1: String? = cast(s)
        
        XCTAssertNotNil(sut1)
        XCTAssertEqual(sut1, "Hi")
        
        let b: Any = true
        
        let sut2: Bool? = cast(b)
        
        XCTAssertNotNil(sut2)
        XCTAssertEqual(sut2, true)
    }
    
    func testCastKO() throws {
        let s: Any = "Hi"
        
        let sut1: Bool? = cast(s)
        
        XCTAssertNil(sut1)
        
        let b: Any = true
        
        let sut2: String? = cast(b)
        
        XCTAssertNil(sut2)
    }
    
    func testCompose() throws {
        let f: (String) -> Bool = { $0 == "Hi" }
        let g: (Bool) -> Int = { $0 ? 1 : 0 }
        
        let sut = compose(f, g)
        
        let r = sut("Hi")
        
        XCTAssertEqual(r, 1)
        
        let n = sut("World")
        
        XCTAssertEqual(n, 0)
    }

    func testComposeOperator() throws {
        let f: (String) -> Bool = { $0 == "Hi" }
        let g: (Bool) -> Int = { $0 ? 1 : 0 }
        
        let sut = f >>> g
        
        let r = sut("Hi")
        
        XCTAssertEqual(r, 1)
        
        let n = sut("World")
        
        XCTAssertEqual(n, 0)
    }

    
    func testFunctionApplicationXF() {
        let x = "Hi"
        let f: (String) -> Int = { $0.count }
        
        let c = x |> f
        
        XCTAssertEqual(c, 2)
    }
    
    func testFunctionApplicationXOptionalF() {
        var x: String? = "Hi"
        let f: (String) -> Int = { $0.count }
        
        let c = x |> f
        
        XCTAssertNotNil(c)
        XCTAssertEqual(c, 2)
        
        x = nil
        
        let oc = x |> f
        
        XCTAssertNil(oc)
    }

    func testFunctionApplicationXFOptional() {
        let x = "Hi"
        var f: ((String) -> Int)? = { $0.count }
        
        let c = x |> f
        
        XCTAssertNotNil(c)
        XCTAssertEqual(c, 2)
        
        f = nil

        let co = x |> f
        
        XCTAssertNil(co)
    }

    func testFunctionApplicationXFrOptional() {
        let x = "Hi"
        let f: (String) -> Int? = { $0.count }
        
        let c = x |> f
        
        XCTAssertNotNil(c)
        XCTAssertEqual(c, 2)
    }
    
    func testFunctionApplicationXFOptionalrOptional() {
        let x = "Hi"
        var f: ((String) -> Int?)? = { $0.count }
        
        let c = x |> f
        
        XCTAssertNotNil(c)
        XCTAssertEqual(c, 2)
        
        f = nil
        
        let co = x |> f
        
        XCTAssertNil(co)
    }


    func testFunctionApplicationXOptionalFOptional() {
        var x: String? = "Hi"
        var f: ((String) -> Int)? = { $0.count }
        
        let c = x |> f
        
        XCTAssertNotNil(c)
        XCTAssertEqual(c, 2)
        
        x = nil
        
        let cxo = x |> f
        
        XCTAssertNil(cxo)

        f = nil
        
        let cfo = x |> f
        
        XCTAssertNil(cfo)
        
        x = "H"
        
        let cofo = x |> f
        
        XCTAssertNil(cofo)
    }

    func testFunctionApplicationXOptionalFOptionalrOptional() {
        var x: String? = "Hi"
        var f: ((String) -> Int?)? = { $0.count }
        
        let c = x |> f
        
        XCTAssertNotNil(c)
        XCTAssertEqual(c, 2)
        
        x = nil
        
        let cxo = x |> f
        
        XCTAssertNil(cxo)
        
        f = nil
        
        let cfo = x |> f
        
        XCTAssertNil(cfo)
        
        x = "H"
        
        let cofo = x |> f
        
        XCTAssertNil(cofo)
    }

}
