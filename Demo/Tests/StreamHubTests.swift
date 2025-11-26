//
//  StreamHubTests.swift
//  Demo
//
//  Created by Yanis Plumit on 25.11.2025.
//

import Foundation
import XCTest
@testable import Demo
import Combine

final class StreamHubTests: XCTestCase {
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func test_streamHub_yieldsCurrentAndUpdatedValues() {
        let hub = StreamHub<Int>(0)
        
        // expectations
        let stream1IsStarted = expectation(description: "Stream 1 is started")
        let stream2IsStarted = expectation(description: "Stream 2 is started")
        let stream1Done = expectation(description: "Receive 3 values")
        let stream2Done = expectation(description: "Receive 2 values")
        
        var receivedBy1: [Int] = []
        var receivedBy2: [Int] = []
        
        // First stream — with current value
        Task {
            let stream = await hub.stream(yieldCurrentValue: true)
            
            stream1IsStarted.fulfill()
            
            for await value in stream {
                receivedBy1.append(value)
                if receivedBy1.count >= 3 {
                    break
                }
            }
            stream1Done.fulfill()
        }
        
        // Second stream — only updates
        Task {
            let stream = await hub.stream()
            
            stream2IsStarted.fulfill()
            
            for await value in stream {
                receivedBy2.append(value)
                if receivedBy2.count >= 2 {
                    break
                }
            }
            stream2Done.fulfill()
        }
        
        // Ensure both subscribers are listening
        wait(for: [stream1IsStarted, stream2IsStarted], timeout: 1.0)
        
        // Emit values
        Task {
            await hub.set(1)
            await hub.set(2)
        }
        
        // Wait for both streams
        wait(for: [stream1Done, stream2Done], timeout: 1.0)
        
        // Check
        XCTAssertEqual(receivedBy1, [0, 1, 2])
        XCTAssertEqual(receivedBy2, [1, 2])
    }
    
    func test_streamHub_getAndSet() async {
        let hub = StreamHub<Int>(10)
        
        let initial = await hub.get()
        XCTAssertEqual(initial, 10)
        
        await hub.set(42)
        
        let updated = await hub.get()
        XCTAssertEqual(updated, 42)
    }
    
    func test_streamHub_getAndSet_optional() async {
        let hub = StreamHub<Int?>(nil)
        
        let initial = await hub.get()
        XCTAssertEqual(initial, nil)
        
        await hub.set(42)
        
        let updatedTo42 = await hub.get()
        XCTAssertEqual(updatedTo42, 42)
        
        await hub.set(nil)
        
        let updatedToNil = await hub.get()
        XCTAssertEqual(updatedToNil, nil)
    }
}

