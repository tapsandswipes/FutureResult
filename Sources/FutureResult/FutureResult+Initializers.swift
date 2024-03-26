import Foundation


public
extension FutureResult {
    
    /// Initialize a FutureResult that will return a constant value
    /// - Parameter value: the value to return
    init(value: R) {
        self.init {
            $0(.success(value))
        }
    }
    
    /// Initialize a FutureResult that will return a constant error
    /// - Parameter error: the error to return
    init(error: E) {
        self.init {
            $0(.failure(error))
        }
    }
    
    /// Initialize a FutureResult that will return a constant Result
    /// - Parameter result: the result to return
    init(_ result: Result<R, E>) {
        self.init {
            $0(result)
        }
    }
    
    
}
