import Foundation


public
extension FutureResult {
    
    /// Generate  new future that transform its value to void
    /// - Returns: a new future properly configured
    func toVoid() -> FutureResult<Void, E> {
        map { _ in () }
    }
    
    /// Generate  new future that cast its error to `Error`
    /// - Returns: a new future properly configured
    func toError() -> FutureResult<R, Error> {
        mapError { $0 as Error }
    }
        
    /// Generate a new future that transform its error to a result
    /// - Parameter f: the block to use to perform the transformation
    /// - Returns: a new future properly configured
    func replaceError(_ f: @escaping (E) -> R) -> FutureResult<R, Never> {
        mapError { .success(f($0)) }
    }
    
    /// Generate a new future that transform its error to a fixed result
    /// - Parameter result: the result to use
    /// - Returns: a new future properly configured
    func replaceError(with result: R) -> FutureResult<R, Never> {
        mapError { _ in .success(result) }
    }
    
    /// Generat a new future that will never call the calback on errors
    /// Be careful whit this method as can lead to a future that never ends
    /// - Returns: a new future properly configured
    func ignoreOnError() -> FutureResult<R, Never> {
        FutureResult<R, Never> { callback in
            self.run { r in
                if case .success(let v) = r {
                    callback(.success(v))
                }
            }
        }
    }
    
    /// Generate a new future that transform its results to a fixed result
    /// - Parameter obj: the result to use
    /// - Returns: a new future properly configured
    func replaceResult<U>(with obj: U) -> FutureResult<U, E> {
        map { _ in obj }
    }
    
}
