//
//  Combine+AsyncStream.swift
//  Demo
//
//  Created by Yanis Plumit on 21.11.2025.
//

import Combine

/// Extension to convert any Combine publisher to an AsyncStream.
/// This enables bridging Combine pipelines into Swift concurrency workflows.
extension AnyPublisher {
    /// Returns an AsyncStream of publisher outputs.
    var asyncStream: AsyncStream<Output> {
        AsyncStream { continuation in
            let cancellable = self.sink(
                receiveCompletion: { _ in
                    continuation.finish()
                },
                receiveValue: { value in
                    // Yield each received value to the async stream.
                    continuation.yield(value)
                }
            )
            continuation.onTermination = { _ in
                cancellable.cancel()
            }
        }
    }
}

/// Extension to convert a @Published property's Publisher into an AsyncStream.
/// Useful for observing property changes within Swift concurrency contexts.
extension Published.Publisher {
    /// Returns an AsyncStream of published values.
    var asyncStream: AsyncStream<Output> {
        AsyncStream { continuation in
            let cancellable = self.sink { value in
                // Yield each published value to the async stream.
                continuation.yield(value)
            }
            continuation.onTermination = { _ in
                cancellable.cancel()
            }
        }
    }
}

