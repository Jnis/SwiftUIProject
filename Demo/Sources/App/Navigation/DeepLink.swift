//
//  DeepLink.swift
//  Demo
//
//  Created by Yanis Plumit on 24.11.2025.
//

import Foundation

/// The `DeepLink` enum defines supported deep link destinations in the app.
/// Each case can be converted to a URL string or compared for equality.
enum DeepLink: Equatable {
    case tabAsyncStream
    case tabCombine
    case tabNavigation
    case demoScreenFullScreen(id: String)
    case demoScreenSheet(id: String)
    
    var id: String {
        return toStringLink
    }
    
    /// Generates a URL string representation of the deep link.
    /// Examples:
    /// ?screen=news
    /// ?screen=news/detail&id=31241512
    var toStringLink: String {
        let components: URLComponents = {
            switch self {
            case .tabAsyncStream:
                return Link(screen: .tabAsyncStream).components()
            case .tabCombine:
                return Link(screen: .tabCombine).components()
            case .tabNavigation:
                return Link(screen: .tabNavigation).components()
            case .demoScreenFullScreen(let id):
                return Link(screen: .demoScreenFullScreen, id: id).components()
            case .demoScreenSheet(let id):
                return Link(screen: .demoScreenSheet, id: id).components()
            }
        }()
        return components.url?.absoluteString ?? ""
    }
    
    static func == (lhs: DeepLink, rhs: DeepLink) -> Bool {
        return lhs.id == rhs.id
    }
}

// MARK: - DeepLink Extensions

extension DeepLink {
    
    /// The custom URL scheme for the application, used in deep links.
    static var appScheme: String {
        "demoapp"
    }
    
    /// Common query parameter keys used in deep links.
    struct QueryKeys {
        static let screen = "screen"
        static let id = "id"
        static let url = "url"
    }
    
    /// Screens supported by deep linking in the app.
    enum ScreenValue: String {
        case tabAsyncStream = "async_stream"
        case tabCombine = "combine"
        case tabNavigation = "navigation"
        case demoScreenFullScreen = "screen/fullscreen"
        case demoScreenSheet = "screen/sheet"
    }
    
    /// Helper struct to build URL components for a deep link.
    ///
    /// Example: demoapp://?screen=async_stream&id=123
    private struct Link {
        let screen: ScreenValue
        var id: String?
        var url: URL?
        
        /// Assembles the components of the deep link URL.
        func components() -> URLComponents {
            var components = URLComponents()
            var queryItems = components.queryItems ?? []
            queryItems.append(.init(name: QueryKeys.screen, value: self.screen.rawValue))
            if let id = self.id {
                queryItems.append(.init(name: QueryKeys.id, value: id))
            }
            if let url = self.url {
                queryItems.append(.init(name: QueryKeys.url, value: url.absoluteString))
            }
            components.queryItems = queryItems
            components.scheme = appScheme
            components.host = ""
            return components
        }
    }
}

