import Foundation
import XCTest
@testable import Demo
import Combine

final class AsyncStreamTests: XCTestCase {
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    // MARK: - Test Service functionality
    func test_service_value() async {
        let service = AsyncStreamService()
        
        let initial = await service.model().value
        XCTAssertEqual(initial, 0)
        
        await service.setModel(Model(value: 5))
        let updated = await service.model().value
        XCTAssertEqual(updated, 5)
    }
    
    func test_service_stream() async {
        let service = AsyncStreamService()
        let expectation = expectation(description: "Receive 3 values")
        var received: [Int] = []
        
        let stream = await service.modelStream()
        Task {
            for await v in stream {
                received.append(v.value)
                if received.count >= 3 {
                    break
                }
            }
            expectation.fulfill()
        }
        
        Task {
            await service.setModel(Model(value: 1))
            await service.setModel(Model(value: 2))
            await service.setModel(Model(value: 3))
        }
        
        await fulfillment(of: [expectation], timeout: 1.0)
        XCTAssertEqual(received, [1, 2, 3])
    }
    
    // MARK: - Test ViewModel updates
    @MainActor
    func test_viewModel_updates() async {
        let service = AsyncStreamService()
        let viewModel = AsyncStreamViewModel(0)
        await viewModel.inject(service: service)
        let expectation = expectation(description: "ViewModel receives initial and incremented values")
        let testValues: [Int] = [viewModel.model.value, 1, 2, 4, 8, 16]
        var receivedValues: [Int] = []
        
        Task {
            while receivedValues.count < testValues.count {
                if receivedValues.last != viewModel.model.value {
                    receivedValues.append(viewModel.model.value)
                }
                await Task.yield()
            }
            expectation.fulfill()
        }
        
        Task {
            for value in testValues {
                try? await Task.sleep(nanoseconds: 10_000_000)
                viewModel.changeValue(value)
            }
        }
        
        await fulfillment(of: [expectation], timeout: 1.0)
        XCTAssertEqual(receivedValues, testValues)
    }
    
    @MainActor
    func test_viewModel_fastUpdates() async {
        let service = AsyncStreamService()
        let viewModel = AsyncStreamViewModel(0)
        await viewModel.inject(service: service)
        let expectation = expectation(description: "ViewModel receives initial and incremented values")
        let testValues: [Int] = [viewModel.model.value, 1, 2, 4, 8, 16]
        var receivedValues: [Int] = []
        
        Task {
            while receivedValues.last != testValues.last {
                if receivedValues.last != viewModel.model.value {
                    receivedValues.append(viewModel.model.value)
                }
                await Task.yield()
            }
            expectation.fulfill()
        }
        
        Task {
            for value in testValues {
                viewModel.changeValue(value)
                await Task.yield()
            }
        }
        
        await fulfillment(of: [expectation], timeout: 1.0)
        print("Sent: \(testValues). Received: \(receivedValues)")
        XCTAssertEqual(receivedValues.last, testValues.last)
    }
    
    @MainActor
    func test_viewModel_injection() async {
        let service = AsyncStreamService()
        let viewModel = AsyncStreamViewModel(0)
        
        await viewModel.inject(service: service)
        await viewModel.inject(service: service)
        await viewModel.inject(service: service)
        
        let expectation = expectation(description: "ViewModel receives incremented values")
        let testValues: [Int] = [viewModel.model.value, 1, 2, 3]
        var receivedValues: [Int] = []
        
        var cancellables: Set<AnyCancellable> = Set()
        viewModel.$model
            .dropFirst()
            .sink { model in
                receivedValues.append(model.value)
                if receivedValues.count == testValues.count {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        Task {
            for value in testValues {
                viewModel.changeValue(value)
                try? await Task.sleep(nanoseconds: 10_000_000)
            }
        }
        
        await fulfillment(of: [expectation], timeout: 1.0)
        XCTAssertEqual(receivedValues, testValues)
    }
}

