//
//  AsyncStreamService.swift
//  Demo
//
//  Created by Yanis Plumit on 21.11.2025.
//

/// Protocol defining an async/await-based model service with async stream support.
protocol AsyncStreamServiceProtocol: Sendable {
    /// Returns the current model value.
    func model() async -> Model
    /// Updates the model with a new value.
    func setModel(_ v: Model) async
    /// Returns an AsyncStream that publishes model updates.
    func modelStream() async -> AsyncStream<Model>
}

/// Actor-based implementation of `AsyncStreamServiceProtocol` that uses a `StreamHub` for state management.
/// Provides async/await and streaming access to the app model.
actor AsyncStreamService: AsyncStreamServiceProtocol {
    /// The underlying stream hub for broadcasting model changes.
    private let valueStreamHub = StreamHub<Model>(Model(value: 0))

    /// Returns the current model value.
    func model() async -> Model {
        await valueStreamHub.get()
    }
    
    /// Updates the model with a new value.
    func setModel(_ newValue: Model) async {
        await valueStreamHub.set(newValue)
    }

    /// Returns an AsyncStream that emits model updates.
    func modelStream() async -> AsyncStream<Model> {
        await valueStreamHub.stream()
    }
}

