//
//  AnyScreen.swift
//  Demo
//
//  Created by Yanis Plumit on 25.11.2025.
//

import SwiftUI

/// A type-erased screen for use in navigation stacks or modal flows.
/// Wraps any SwiftUI `View` and provides a unique identity for use in collections.
struct AnyScreen: Hashable, Identifiable {
    
    let id = UUID()
    /// Closure that builds the associated view, type-erased as `AnyView`.
    let build: () -> AnyView
    
    /// Convenience factory to wrap any SwiftUI `View` into an `AnyScreen`.
    static func create<T: View>(_ view: T) -> AnyScreen {
        AnyScreen(build: { AnyView(view) })
    }
    
    static func == (lhs: AnyScreen, rhs: AnyScreen) -> Bool { lhs.id == rhs.id }
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

