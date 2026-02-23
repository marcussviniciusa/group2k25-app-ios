import UIKit
import UserNotifications
import os

private let logger = Logger(subsystem: "com.group2k25", category: "PushNotifications")

class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        UNUserNotificationCenter.current().delegate = self
        requestNotificationPermission()
        return true
    }

    // MARK: - Permission

    private func requestNotificationPermission() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error {
                logger.error("Push permission error: \(error.localizedDescription)")
                return
            }
            if granted {
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                }
                logger.info("Push permission granted")
            } else {
                logger.info("Push permission denied")
            }
        }
    }

    // MARK: - Device Token

    func application(
        _ application: UIApplication,
        didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
    ) {
        let token = deviceToken.map { String(format: "%02x", $0) }.joined()
        logger.info("Device token: \(token)")
        UserDefaults.standard.set(token, forKey: "deviceToken")
        sendTokenToServer(token)
    }

    func application(
        _ application: UIApplication,
        didFailToRegisterForRemoteNotificationsWithError error: Error
    ) {
        logger.error("Failed to register for push: \(error.localizedDescription)")
    }

    private func sendTokenToServer(_ token: String) {
        guard KeychainHelper.shared.read(key: "auth_token") != nil else {
            logger.info("Device token saved locally, will send after login")
            return
        }
        Task {
            do {
                try await APIClient.shared.requestVoid(.registerDevice(token: token))
                logger.info("Device token sent to server")
            } catch {
                logger.error("Failed to send device token: \(error.localizedDescription)")
            }
        }
    }

    /// Call this after login to send any pending device token
    static func sendPendingDeviceToken() {
        guard let token = UserDefaults.standard.string(forKey: "deviceToken") else { return }
        Task {
            do {
                try await APIClient.shared.requestVoid(.registerDevice(token: token))
                logger.info("Pending device token sent to server")
            } catch {
                logger.error("Failed to send pending device token: \(error.localizedDescription)")
            }
        }
    }

    // MARK: - Receive Notifications

    // Foreground: show banner even when app is open
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        completionHandler([.banner, .sound, .badge])
    }

    // User tapped the notification
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void
    ) {
        let userInfo = response.notification.request.content.userInfo

        if let contractId = userInfo["contract_id"] as? String {
            NotificationCenter.default.post(
                name: .pushNavigateToContract,
                object: nil,
                userInfo: ["contract_id": contractId]
            )
        }

        completionHandler()
    }
}

extension Notification.Name {
    static let pushNavigateToContract = Notification.Name("pushNavigateToContract")
}
