//
//  File.swift
//  
//
//  Created by Antonio Cabezuelo Vivo on 5/4/21.
//

import Foundation


public
extension FutureResult {
    
    func deliver(on queue: DispatchQueue) -> Self {
        Self { callback in
            self.run { r in
                queue.async {
                    callback(r)
                }
            }
        }
    }
    
    func perform(in queue: DispatchQueue) -> Self {
        Self { cb in
            queue.async {
                self.run(cb)
            }
        }
    }
    
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

    func sleep(_ interval: TimeInterval) -> Self {
        return Self { callback in
            self.run {
                Thread.sleep(forTimeInterval: interval)
                callback($0)
            }
        }
    }

}

private let waitQueue = DispatchQueue(label: "com.tas.future.wait-queue", attributes: .concurrent)

