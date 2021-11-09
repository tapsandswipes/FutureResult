//
//  File.swift
//  
//
//  Created by Antonio Cabezuelo Vivo on 5/11/21.
//

import Foundation

#if swift(>=5.5.2)

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
public
extension FutureResult {
    func run() async -> Result<R, E> {
        await withCheckedContinuation { self.run($0.resume) }
    }
    
    func run() async throws -> R {
        try await withCheckedThrowingContinuation { self.run($0.resume) }
    }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
public
extension FutureResult where R == Void {
    func run() async throws {
        _ = try await withCheckedThrowingContinuation { self.run($0.resume) }
    }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
public
extension FutureResult where E == Never {
    func run() async -> R {
        await withCheckedContinuation { self.run($0.resume) }
    }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
public
extension FutureResult where R == Void, E == Never {
    func run() async {
        _ = await withCheckedContinuation { c in self.run { _ in c.resume() } }
    }
}

#endif
