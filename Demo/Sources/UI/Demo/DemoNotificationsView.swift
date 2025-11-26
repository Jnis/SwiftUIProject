//
//  DemoNotificationsView.swift
//  Demo
//
//  Created by Yanis Plumit on 24.11.2025.
//

import SwiftUI

struct DemoNotificationsView: View {
    private let notificationCenter = UNUserNotificationCenter.current()
    
    var body: some View {
        ScrollView {
            Text("DeepLinks").font(.title2).bold()
            
            Button("to tabAsyncStream", action: {
                requestAuthorization(completion: { _ in
                    sendTestNotification(link: DeepLink.tabAsyncStream.toStringLink)
                })
            })
            
            Button("to tabCombine", action: {
                requestAuthorization(completion: { _ in
                    sendTestNotification(link: DeepLink.tabCombine.toStringLink)
                })
            })
            
            Button("to tabNavigation", action: {
                requestAuthorization(completion: { _ in
                    sendTestNotification(link: DeepLink.tabNavigation.toStringLink)
                })
            })
            
            Button("to demoScreenFullScreen", action: {
                requestAuthorization(completion: { _ in
                    sendTestNotification(link: DeepLink.demoScreenFullScreen(id: "fromLinkFullScreen").toStringLink)
                })
            })
            
            Button("to demoScreenSheet", action: {
                requestAuthorization(completion: { _ in
                    sendTestNotification(link: DeepLink.demoScreenSheet(id: "fromLinkSheet").toStringLink)
                })
            })
        }
    }
    
    private func sendTestNotification(title: String = "Test", link: String?) {
        let timeDelay: TimeInterval = 3
        
        let fireTime = Calendar(identifier: .gregorian).dateComponents([.year, .month, .day, .hour, .minute, .second, .timeZone], from: Date().addingTimeInterval(timeDelay))
        
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = "\(link ?? "-")"
        if let link = link {
            content.userInfo = [
                "deeplink": link
            ]
        }
        content.sound = UNNotificationSound.default
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: fireTime, repeats: false)
        let request = UNNotificationRequest(identifier: "test id", content: content, trigger: trigger)
        
        notificationCenter.add(request) { (error) in
            if let error = error {
                print("Error \(error.localizedDescription)")
            }
        }
    }
    
    private func checkAuthorizationStatus(completion: ((UNAuthorizationStatus) -> Void)?) {
        notificationCenter.getNotificationSettings { settings in
            DispatchQueue.main.async {
                switch settings.authorizationStatus {
                case .authorized:
                    print("✅ Notification permission was granted")
                    completion?(.authorized)
                case .denied:
                    print("❌ Notification permission was denied")
                    completion?(.denied)
                case .provisional:
                    print("💤 Notification permission was granted but only provisional")
                    completion?(.provisional)
                case .notDetermined:
                    print("📲 Notification Settings are not yet set")
                    completion?(.notDetermined)
                default:
                    print("⚠️ Notification Settings not handled")
                }
            }
        }
    }
    
    private func requestAuthorization(completion: ((UNAuthorizationStatus) -> Void)?) {
        checkAuthorizationStatus { status in
            if status == .notDetermined || status == .provisional {
                let options: UNAuthorizationOptions = [.alert, .sound, .badge]
                self.notificationCenter.requestAuthorization(options: options) { _, error in
                    DispatchQueue.main.async {
                        if completion != nil {
                            self.checkAuthorizationStatus { status in
                                completion?(status)
                            }
                        }
                    }
                }
            } else {
                completion?(status)
            }
        }
    }
}
