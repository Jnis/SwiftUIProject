//
//  StreamHub.swift
//  Demo
//
//  Created by Yanis Plumit on 21.11.2025.
//

import Foundation

/// An actor that holds a value of type `T` and provides asynchronous streaming of value changes.
/// 
/// Clients can:
/// - Get/set the current value safely from any concurrency context
/// - Subscribe to an `AsyncStream` to receive value updates as they occur
/// 
/// The hub ensures all subscribers receive newly set values, and can optionally yield the current value when subscribing.
actor StreamHub<T: Sendable> {
    /// The current value being managed and broadcasted.
    private var value: T

    /// Tracks all active async stream continuations, keyed by UUID.
    private var continuations: [UUID: AsyncStream<T>.Continuation] = [:]
    
    /// Initializes the hub with an initial value.
    init(_ initial: T) { value = initial }

    /// Cleans up all stream continuations when the hub is deallocated, signaling all subscribers to finish.
    deinit {
        continuations.values.forEach { $0.finish() }
    }
    
    /// Returns the current value, asynchronously.
    func get() async -> T { value }

    /// Sets a new value and notifies all active subscribers.
    func set(_ newValue: T) async {
        value = newValue
        continuations.values.forEach { $0.yield(newValue) }
    }

    /// Returns an async stream that publishes new values as they are set.
    /// - Parameter yieldCurrentValue: Whether to immediately send the current value upon subscription.
    /// - Returns: An `AsyncStream` emitting values of type `T`.
    func stream(yieldCurrentValue: Bool = false) async -> AsyncStream<T> {
        AsyncStream { continuation in
            let id = UUID()
            // Register the new subscriber.
            continuations[id] = continuation
            // Clean up when the stream terminates.
            continuation.onTermination = { [weak self] _ in
                Task { await self?.removeContinuation(id) }
            }
            // Optionally yield the current value upon subscription.
            if yieldCurrentValue {
                continuation.yield(value)
            }
        }
    }

    /// Removes a finished continuation. Called on stream termination.
    fileprivate func removeContinuation(_ id: UUID) {
        continuations.removeValue(forKey: id)
    }
}
