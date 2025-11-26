//
//  AppEnvironment.swift
//  Demo
//
//  Created by Yanis Plumit on 21.11.2025.
//

import SwiftUI

/// Provides shared application-wide services and dependencies for use with SwiftUI's environment.
/// Use this class to access business logic or models that should be available throughout the app.
@MainActor
final class AppEnvironment: ObservableObject {
    /// Service exposing model state and updates via async/await and AsyncStream.
    let asyncStreamService: AsyncStreamServiceProtocol = AsyncStreamService()
    /// Service exposing model state and updates via Combine.
    let combineService: CombineServiceProtocol = CombineService()
}
