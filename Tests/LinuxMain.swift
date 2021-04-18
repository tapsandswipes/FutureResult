import XCTest

import FutureResultTests

var tests = [XCTestCaseEntry]()
tests += FunctionCompositionTests.allTests()
tests += FutureResultTests.allTests()
tests += FutureResultChainableTests.allTests()
XCTMain(tests)
