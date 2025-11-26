//
//  AppStackNavigationView.swift
//  Demo
//
//  Created by Yanis Plumit on 24.11.2025.
//

import SwiftUI

/// View model for managing a stack-based navigation flow using identifiable screen links.
final class AppStackNavigationViewModel: ObservableObject {
    /// The navigation path, representing the stack of pushed screens.
    @Published fileprivate(set) var path: [StackScreenLinks] = []
    
    /// Pushes a new screen onto the navigation stack.
    func push(_ sheetScreenLink: StackScreenLinks) {
        path.append(sheetScreenLink)
    }
    
    /// Pops the top screen from the navigation stack.
    func pop() {
        _ = path.popLast()
    }
    
    /// Clears the navigation stack, returning to the root screen.
    func popToRoot() {
        path = []
    }
}

/// A wrapper view that provides stack-based navigation context to its content.
/// Use this view to enable push-style navigation using a shared view model.
struct AppStackNavigationView<T: View>: View {
    /// The navigation view model, injected into the environment for descendant views.
    @StateObject var stackNavigation = AppStackNavigationViewModel()
    
    private let label: () -> T
    
    /// Initializes the navigation view with a content builder.
    init(@ViewBuilder _ label: @escaping () -> T) {
        self.label = label
    }
    
    var body: some View {
        NavigationStack(path: $stackNavigation.path) {
            label()
                .navigationDestination(for: StackScreenLinks.self) { screenLink in
                    screenLink.view
                }
        }
        .environmentObject(stackNavigation)
    }
}

