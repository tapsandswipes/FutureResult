import Foundation


/// Type that represents a future Result<R, Error>
public
struct FutureResult<R, E: Error> {

    public typealias Callback = (Result<R, E>) -> Void
    
    /// Block to call to get the future Result. Upon running, it will call the callback with the result value
    public let run: (@escaping Callback) -> Void
    
    public
    init(_ run: @escaping (@escaping Callback) -> Void) {
        self.run = run
    }
}
