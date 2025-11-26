//
//  StreamReader.swift
//  Demo
//
//  Created by Yanis Plumit on 21.11.2025.
//

/// Helps reads AsyncStream to closure. Stops reading on deallocation.
class StreamReaders {
    private var streamReaders: [StreamReaderProtocol] = []
    
    func add<T>(_ stream: AsyncStream<T>, completion: @MainActor @escaping (T) async -> Void) {
        streamReaders.append( StreamReader(stream: stream, completion: completion) )
    }
    
    func removeAll() {
        streamReaders.removeAll()
    }
}

/// Helps StreamReaders to store StreamReader
protocol StreamReaderProtocol { }

/// A helper class that continuously reads values from an AsyncStream
/// and forwards them into the provided async closure.
/// The reading task is automatically cancelled on deinit.
class StreamReader<T>: StreamReaderProtocol {
    private var task: Task<Void, Never>?

    init(stream: AsyncStream<T>, completion: @MainActor @escaping (T) async -> Void) {
        task = Task {
            for await value in stream {
                await completion(value)
            }
        }
    }

    /// Cancels the reading task when this reader is deallocated.
    deinit {
        task?.cancel()
    }
}
