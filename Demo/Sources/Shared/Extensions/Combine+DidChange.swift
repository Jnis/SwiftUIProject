//
//  Combine+DidChange.swift
//  Demo
//
//  Created by Yanis Plumit on 21.11.2025.
//

import SwiftUI
import Combine

extension Published.Publisher {
    
    /// Provides a type-erased publisher that relays all value updates on the main run loop, ensuring thread-safe UI handling.
    var didChange: AnyPublisher<Value, Never> {
        self.dropFirst()
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }
    
    /// Provides a type-erased publisher that maps every value update to Void, ensuring the event is delivered on the main run loop.
    var didChangeVoided: AnyPublisher<Void, Never> {
        self.dropFirst()
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
            .map { _ in () }
            .eraseToAnyPublisher()
    }
    
}

extension AnyPublisher {
    
    /// Returns a publisher that emits all values on the main run loop after dropping the first emission.
    /// Useful for UI updates that must occur on the main thread.
    var didChange: AnyPublisher<Output, Failure> {
        self.dropFirst()
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }
    
    /// Returns a publisher that emits `Void` for every value on the main run loop after dropping the first emission.
    /// Useful for triggering UI updates without caring about the value.
    var didChangeVoided: AnyPublisher<Void, Failure> {
        self.dropFirst()
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
            .map { _ in () }
            .eraseToAnyPublisher()
    }
    
}

