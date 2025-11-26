//
//  CombineService.swift
//  Demo
//
//  Created by Yanis Plumit on 23.11.2025.
//

import Combine

/// Protocol defining a Combine-based model service that exposes a model and its updates via publisher.
@MainActor
protocol CombineServiceProtocol {
    /// The current model value.
    var model: Model { get set }
    /// A publisher that emits model updates.
    var modelPublisher: AnyPublisher<Model, Never> { get }
}

/// Main-actor implementation of `CombineServiceProtocol`, providing model state and publisher.
/// Uses `@Published` for value observation and Combine for reactivity.
@MainActor 
final class CombineService: CombineServiceProtocol {
    /// The current model value, published using Combine.
    @Published var model: Model = Model(value: 0)
    
    /// A publisher emitting all model updates.
    var modelPublisher: AnyPublisher<Model, Never> {
        $model.eraseToAnyPublisher()
    }
}

