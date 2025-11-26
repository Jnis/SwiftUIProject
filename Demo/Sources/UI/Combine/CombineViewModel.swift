//
//  CombineViewModel.swift
//  Demo
//
//  Created by Yanis Plumit on 23.11.2025.
//

import SwiftUI
import Combine

@MainActor
final class CombineViewModel: ObservableObject {
    private var cancellables: Set<AnyCancellable> = .init()
    private var service: CombineServiceProtocol? // DI
    
    @Published private(set) var model: Model

    init(_ value: Int) {
        self.model = Model(value: value)
    }
    
    deinit {
        print("\(self) \(#function)")
    }
    
    /// Injects a service (should only be called once per instance).
    /// PS: Can be replaced by any DI framework and moved to init.
    func inject(service: CombineServiceProtocol) {
        guard self.service == nil else { return }
        
        self.service = service
        
        // Subscribe to the service's model updates.
        
//        service.modelPublisher
//            .didChange
//            .sink { [weak self] value in
//                self?.update()
//            }
//            .store(in: &cancellables)
        
        // Merge multiple service update signals (easy to add more in the future)
        Publishers.MergeMany(
            service.modelPublisher.didChangeVoided,
            // ...
        )
        .sink(receiveValue: { [weak self] _ in
            self?.update()
        }).store(in: &cancellables)
        
        // Fetch and publish the initial model value.
        self.update()
    }
    
    private func update() {
        guard let service = self.service else { return }
        self.model = service.model
    }

    func changeValue(_ newValue: Int) {
        service?.model = Model(value: newValue)
    }
}
