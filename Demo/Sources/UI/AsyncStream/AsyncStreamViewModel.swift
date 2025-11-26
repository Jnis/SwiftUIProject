//
//  AsyncStreamViewModel.swift
//  Demo
//
//  Created by Yanis Plumit on 21.11.2025.
//

import SwiftUI

@MainActor
final class AsyncStreamViewModel: ObservableObject {
    private let streamReaders = StreamReaders()
    private var service: AsyncStreamServiceProtocol? // DI
    
    @Published private(set) var model: Model

    init(_ value: Int) {
        self.model = Model(value: value)
    }
    
    deinit {
        print("\(self) \(#function)")
    }
    
    /// Injects a service (should only be called once per instance).
    /// PS: Can be replaced by any DI framework and moved to init.
    func inject(service: AsyncStreamServiceProtocol) async {
        guard self.service == nil else { return } 
        
        self.service = service
        
        // Subscribe to the service's model updates.
        let stream = await service.modelStream()
        self.streamReaders.add(stream, completion: { [weak self] value in
            await self?.update()
        })
        
        // Fetch and publish the initial model value.
        await self.update()
    }
    
    private func update() async {
        guard let service = self.service else { return }
        self.model = await service.model()
    }

    func changeValue(_ newValue: Int) {
        Task {
            await service?.setModel(Model(value: newValue))
        }
    }
}
