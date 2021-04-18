import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(FunctionCompositionTests.allTests),
        testCase(FutureResultTests.allTests),
        testCase(FutureResultChainableTests.allTests),
    ]
}
#endif
