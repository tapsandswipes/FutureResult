//
//  File.swift
//  
//
//  Created by Antonio Cabezuelo Vivo on 5/4/21.
//

import Foundation


public
extension FutureResult {
    
    /// Generate a new future by calling the callback in the specified queue
    /// - Parameter queue: the queue whwere the calback should be called
    /// - Returns: a new future properly configured
    func deliver(on queue: DispatchQueue) -> Self {
        Self { callback in
            self.run { r in
                queue.async {
                    callback(r)
                }
            }
        }
    }
    
    /// Generate a new future taht wil run in the specified queue
    /// - Parameter queue: the queue where the future will run
    /// - Returns: a new future properly configured
    func perform(in queue: DispatchQueue) -> Self {
        Self { cb in
            queue.async {
                self.run(cb)
            }
        }
    }
    
    /// Generate a new future that will run synchronously in the specified queue or current queue if no queue  is provided
    /// - Parameter queue: the queue where the future will run
    /// - Returns: a new future properly configured
    func sync(on queue: DispatchQueue? = nil) -> Self {
        FutureResult { cb in
            if let queue = queue {
                queue.async {
                    cb(self.runSync())
                }
            } else {
                cb(self.runSync())
            }
        }
    }
    
    /// Generate a new future that will run synchronously on a arbitrary queue but synchronized be the specified semaphore
    /// - Parameter semaphore: the semaphore to use for synchronization
    /// - Returns: a new future properly configured
    func sync(using semaphore: DispatchSemaphore) -> Self {
        FutureResult { cb in
            waitQueue.async {
                semaphore.wait()
                run {
                    semaphore.signal()
                    cb($0)
                }
            }
        }
    }
    
    /// Generate a new future that will run synchronously in the current queue
    /// - Returns: a new future properly configured
    func runSync() -> Result<R, E> {
        var r: Result<R, E>!
        let semaphore = DispatchSemaphore(value: 0)
        waitQueue.async {
            run {
                r = $0
                semaphore.signal()
            }
        }
        semaphore.wait()
        return r
    }
    
    /// Generate a new future that will run and wait for the specified time interval
    /// - Parameter interval: the time interval to wait before the callback is called
    /// - Returns: a new future properly configured
    func sleep(_ interval: TimeInterval) -> Self {
        return Self { callback in
            self.run { r in
                waitQueue.async {
                    Thread.sleep(forTimeInterval: interval)
                    callback(r)
                }
            }
        }
    }

}

private let waitQueue = DispatchQueue(label: "com.tas.future.wait-queue", attributes: .concurrent)

