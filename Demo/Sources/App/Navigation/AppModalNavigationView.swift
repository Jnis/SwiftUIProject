//
//  AppModalNavigationView.swift
//  Demo
//
//  Created by Yanis Plumit on 23.11.2025.
//

import SwiftUI

/// View model for managing modal and sheet-based navigation flows.
/// Provides methods to present and dismiss modal or sheet screens safely.
final class AppModalNavigationViewModel: ObservableObject {
    /// The currently presented modal screen, if any.
    @Published fileprivate(set) var modalScreenLink: ModalScreenLinks?
    /// The currently presented sheet screen, if any.
    @Published fileprivate(set) var sheetScreenLink: ModalScreenLinks?

    /// Closure to be called for dismissing the current modal.
    fileprivate(set) var modalDismiss: (() -> Void)?

    /// Presents a modal screen. If another modal or sheet is presented, dismisses it first.
    func show(modalScreen modalScreenLink: ModalScreenLinks) {
        showSafely {
            self.modalScreenLink = modalScreenLink
        } 
    }

    /// Presents a sheet screen. If another modal or sheet is presented, dismisses it first.
    func show(sheetScreen sheetScreenLink: ModalScreenLinks) {
        showSafely {
            self.sheetScreenLink = sheetScreenLink
        }
    }
    
    /// Dismisses any presented modal or sheet screens.
    func hideModalScreens() {
        self.modalScreenLink = nil
        self.sheetScreenLink = nil
    }
    
    /// Ensures that only one modal or sheet is presented at a time.
    /// If a screen is already presented, dismisses it before presenting the new one.
    private func showSafely(block: @escaping () -> Void) {
        if self.modalScreenLink == nil && self.sheetScreenLink == nil {
            block()
        } else {
            hideModalScreens()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                block()
            }
        }
    }
}

/// A wrapper view that provides modal and sheet navigation context to its content.
/// Use this view to easily present modals or sheets from anywhere in its hierarchy.
struct AppModalNavigationView<T: View>: View {
    /// The modal navigation view model, injected into the environment for descendant views.
    @StateObject var modalNavigation = AppModalNavigationViewModel()
    /// The system dismiss environment action.
    @Environment(\.dismiss) private var dismiss
    
    private let label: () -> T
    
    /// Initializes the view with a content builder.
    init(@ViewBuilder _ label: @escaping () -> T) {
        self.label = label
    }
    
    var body: some View {
        label()
            .environmentObject(modalNavigation)
            .task {
                modalNavigation.modalDismiss = {
                    dismiss()
                }
            }
            .fullScreenCover(item: $modalNavigation.modalScreenLink, content: { screenLink in
                screenLink.view
            })
            .sheet(item: $modalNavigation.sheetScreenLink, content: { screenLink in
                screenLink.view
            })
    }
}
