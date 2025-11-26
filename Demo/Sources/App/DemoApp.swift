import SwiftUI

/// The main entry point for the Demo application.
/// Configures shared environment objects and notification handling.
@main
struct DemoApp: App {
    /// Holds and manages deep links throughout the app session.
    private let deepLinkHolder = DeepLinkHolder()
    /// Handles notification delivery and user interaction with notifications.
    private let notificationDelegate = NotificationDelegate()
    /// Provides shared services and dependencies for the app.
    @MainActor var appEnvironment = AppEnvironment()
    
    init() {
        // Set the notification center delegate and define how notification deep links are handled.
        UNUserNotificationCenter.current().delegate = notificationDelegate
        notificationDelegate.handleNotification = { [weak deepLinkHolder] info in
            let link: String? = info["deeplink"] as? String
            print("DeepLink: \(link ?? "nil")")
            if let link, let url = URL(string: link) {
                deepLinkHolder?.handle(url: url)
            }
        }
    }
    
    var body: some Scene {
        WindowGroup {
            AppModalNavigationView {
                MainView()
                    .environmentObject(self.deepLinkHolder)
            }
            .environmentObject(appEnvironment)
        }
    }
}

/// Delegate for handling user notifications and propagating notification data to the app.
/// Implements `UNUserNotificationCenterDelegate` and provides a closure for notification payload handling.
final class NotificationDelegate: NSObject, ObservableObject, UNUserNotificationCenterDelegate {
    /// Closure to handle custom notification data (e.g., deep link info).
    var handleNotification: (([AnyHashable : Any]) -> Void)?
    
    /// Called when a notification is delivered while the app is in the foreground.
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .sound, .badge, .list])
    }
    
    /// Called when the user interacts with a notification (e.g., tap).
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        handleNotification?(userInfo)
        completionHandler()
    }
    
}
