//
//  CombineTests.swift
//  Demo
//
//  Created by Yanis Plumit on 24.11.2025.
//

import Foundation
import XCTest
@testable import Demo
import Combine

@MainActor
final class CombineTests: XCTestCase {
    
    var service: CombineService!
    var viewModel: CombineViewModel!
    var cancellables: Set<AnyCancellable>!
    
    override func setUp() async throws {
        service = CombineService()
        viewModel = CombineViewModel(-1)
        cancellables = []
    }
    
    override func tearDown() async throws {
        service = nil
        viewModel = nil
        cancellables = nil
    }
    
    func test_viewModel_initialValue() throws {
        service.model = Model(value: 10)
        viewModel.inject(service: service)
        XCTAssertEqual(viewModel.model.value, 10)
    }
    
    func test_viewModel_updatesViaService() async throws {
        viewModel.inject(service: service)
        
        let expectation = expectation(description: "Value should update")
        let testValue = 123
        
        viewModel.$model
            .dropFirst()
            .sink { model in
                if model.value == testValue {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        service.model = Model(value: testValue)
        
        await fulfillment(of: [expectation], timeout: 1.0)
        XCTAssertEqual(viewModel.model.value, testValue)
    }
    
    func test_service_updatedViaViewModel() async throws {
        viewModel.inject(service: service)
        viewModel.changeValue(77)
        XCTAssertEqual(service.model.value, 77)
    }
    
    func test_service_emitsMultipleChanges() async throws {
        viewModel.inject(service: service)
        
        let expectation = expectation(description: "Receive 3 values")
        var received: [Int] = []
        let testValues: [Int] = [1, 2, 3]
        
        viewModel.$model
            .dropFirst()
            .sink { model in
                received.append(model.value)
                if model.value == testValues.last! {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        for value in testValues {
            service.model = Model(value: value)
            try await Task.sleep(nanoseconds: 10_000_000)
        }
        
        await fulfillment(of: [expectation], timeout: 1.0)
        XCTAssertEqual(received, testValues)
    }
    
    func test_viewModel_multipleInjection() async throws {
        viewModel.inject(service: service)
        viewModel.inject(service: service)
        viewModel.inject(service: service)
        
        let expectation = expectation(description: "Receive 3 values")
        var received: [Int] = []
        let testValues: [Int] = [1, 2, 3]
        
        viewModel.$model
            .dropFirst()
            .sink { model in
                received.append(model.value)
                if model.value == testValues.last! {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        for value in testValues {
            service.model = Model(value: value)
            try await Task.sleep(nanoseconds: 10_000_000)
        }
        
        await fulfillment(of: [expectation], timeout: 1.0)
        XCTAssertEqual(received, [1, 2, 3])
    }
}
