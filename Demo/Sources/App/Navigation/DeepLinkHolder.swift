//
//  DeepLinkHolder.swift
//  Demo
//
//  Created by Yanis Plumit on 24.11.2025.
//

import SwiftUI

/// Holds and manages the current deep link for the application.
/// Handles incoming URLs, parses them into `DeepLink` values, and supports postponing deep link handling until the app is ready.
class DeepLinkHolder: ObservableObject {
    /// The currently handled deep link, if any.
    @Published private(set) var deepLink: DeepLink?
    /// Indicates if the holder is ready to process deep links.
    private var isReady: Bool = false
    /// Stores a postponed URL if received before readiness.
    private var postponedUrl: URL?
    
    /// Marks the holder as ready to handle deep links.
    /// If a URL was received before readiness, it will be handled now.
    func readyToHandle() {
        isReady = true
        if let postponedUrl {
            self.postponedUrl = nil
            handle(url: postponedUrl)
        }
    }
    
    /// Processes the incoming URL as a deep link.
    /// If not ready, postpones handling until `readyToHandle()` is called.
    func handle(url: URL) {
        guard isReady else {
            postponedUrl = url
            return
        }
        
        let deepLink = parseComponents(url: url)
        self.deepLink = deepLink
        // Automatically clears the deep link after 1 second. (this needed to handle same link)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
            if deepLink == self.deepLink {
                self.deepLink = nil
            }
        })
    }
    
    /// Parses the URL's components and tries to construct a `DeepLink` value.
    /// - Parameter url: The URL to parse.
    /// - Returns: A `DeepLink` value if parsing succeeds, otherwise `nil`.
    func parseComponents(url: URL) -> DeepLink? {
        guard let components = NSURLComponents(url: url, resolvingAgainstBaseURL: true),
              let queryItems = components.queryItems,
              queryItems.isEmpty == false else {
            return nil
        }

        guard let screenValue = queryItems.value(forKey: DeepLink.QueryKeys.screen) else {
            print("deeplink \(url.absoluteString) without '\(DeepLink.QueryKeys.screen)' query item.")
            return nil
        }
        guard let screenValue = DeepLink.ScreenValue(rawValue: screenValue) else {
            print("deeplink \(url.absoluteString) has unknown '\(DeepLink.QueryKeys.screen)' value \(screenValue).")
            assertionFailure("deeplink \(url.absoluteString) has unknown '\(DeepLink.QueryKeys.screen)' value \(screenValue).")
            return nil
        }
        
        switch screenValue {
        case .tabAsyncStream:
            return .tabAsyncStream
        case .tabCombine:
            return .tabCombine
        case .tabNavigation:
            return .tabNavigation
        case .demoScreenFullScreen:
            if let idValue = queryItems.value(forKey: DeepLink.QueryKeys.id) {
                return .demoScreenFullScreen(id: idValue)
            } else {
                return nil
            }
        case .demoScreenSheet:
            if let idValue = queryItems.value(forKey: DeepLink.QueryKeys.id) {
                return .demoScreenSheet(id: idValue)
            } else {
                return nil
            }
        }
    }
}

// MARK: - Extensions

private extension Array where Element == URLQueryItem {
    /// Returns the value for the given query item key, if present.
    func value(forKey key: String) -> String? {
        return self.first(where: { $0.name == key})?.value
    }
    
    /// Returns a valid URL for the given query item key, if present and valid.
    func url(forKey key: String) -> URL? {
        if let urlValue = self.value(forKey: key),
           let urlFixed = urlValue.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
           let url = URL(string: urlFixed) {
            return url
        } else {
            return nil
        }
    }
}

