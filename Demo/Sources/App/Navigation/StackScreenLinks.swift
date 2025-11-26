//
//  StackLinks.swift
//  Demo
//
//  Created by Yanis Plumit on 24.11.2025.
//

import SwiftUI

/// Enum representing all possible stack navigation routes in the app.
/// Each case provides a unique identifier and an associated SwiftUI view for navigation.
enum StackScreenLinks: Identifiable, Hashable {
    case demoScreen(value: String)
    case asyncStreamScreen(value: String)
    case combineScreen(value: String)
    case anyScreen(screen: AnyScreen)
    
    /// Unique identifier for this link.
    var id: String {
        switch self {
        case .demoScreen(let value): return "demoScreen_\(value)"
        case .asyncStreamScreen(let value): return "asyncStreamScreen_\(value)"
        case .combineScreen(let value): return "combineScreen_\(value)"
        case .anyScreen(let screen): return "anyScreen_\(screen.id)"
        }
    }
    
    /// The corresponding SwiftUI view for this navigation link.
    @ViewBuilder var view: some View {
        switch self {
        case .demoScreen(let value):
            DemoScreenView(value: value)
        case .asyncStreamScreen(let value):
            VStack {
                DemoScreenView(value: value)
                AsyncStreamView()
            }
        case .combineScreen(let value):
            VStack {
                DemoScreenView(value: value)
                CombineView()
            }
        case .anyScreen(let anyScreen):
            anyScreen.build()
        }
    }
}
