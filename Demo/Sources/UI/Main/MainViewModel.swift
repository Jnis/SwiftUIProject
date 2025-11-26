//
//  MainViewModel.swift
//  Demo
//
//  Created by Yanis Plumit on 21.11.2025.
//

import SwiftUI

extension MainViewModel.Tabs {
    var image: Image {
        switch self {
        case .asyncStreamScreen: return Image(systemName: "square.split.2x2.fill")
        case .combineScreen: return Image(systemName: "square.fill")
        case .navigationScreen: return Image(systemName: "square.stack.fill")
        }
    }
    
    var title: String {
        switch self {
        case .asyncStreamScreen: return "Async Stream"
        case .combineScreen: return "Combine"
        case .navigationScreen: return "Navigation"
        }
    }
    
    @ViewBuilder var view: some View {
        AppStackNavigationView {
            switch self {
            case .asyncStreamScreen:
                AsyncStreamView()
            case .combineScreen:
                CombineView()
            case .navigationScreen:
                DemoScreenView(value: "Root")
            }
        }
    }
}

extension MainViewModel {
    enum Tabs: String, CaseIterable, Identifiable {
        var id: String { rawValue }
        
        case asyncStreamScreen
        case combineScreen
        case navigationScreen
    }
}

@Observable
final class MainViewModel {
    let availableTabs: [Tabs] = Tabs.allCases
    var currentTab: Tabs = Tabs.allCases[0]
}
