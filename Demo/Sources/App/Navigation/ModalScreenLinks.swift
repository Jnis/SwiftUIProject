//
//  ModalScreenLinks.swift
//  Demo
//
//  Created by Yanis Plumit on 24.11.2025.
//

import SwiftUI

/// Enum representing all modal screen routes available in the app.
/// Each case can generate its own unique identifier and destination view.
enum ModalScreenLinks: Identifiable {
    case demoScreen(value: String)
    
    /// Unique identifier for this link.
    var id: String {
        switch self {
        case .demoScreen(let value): return "demoScreen_\(value)"
        }
    }
    
    /// The SwiftUI view to present for this modal screen link.
    @ViewBuilder var view: some View {
        AppModalNavigationView {
            AppStackNavigationView {
                switch self {
                case .demoScreen(let value):
                    DemoScreenView(value: value)
                }
            }
        }
    }
}

