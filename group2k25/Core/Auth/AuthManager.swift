import Foundation
import Observation

enum AuthState: Sendable {
    case loading
    case unauthenticated
    case authenticated(User)
}

@Observable
@MainActor
final class AuthManager {
    var state: AuthState = .loading
    var currentUser: User?

    var isAuthenticated: Bool {
        if case .authenticated = state { return true }
        return false
    }

    private let client = APIClient.shared

    init() {
        NotificationCenter.default.addObserver(
            forName: .authSessionExpired,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            Task { @MainActor in
                self?.handleSessionExpired()
            }
        }
    }

    func checkSession() async {
        guard KeychainHelper.shared.read(key: "auth_token") != nil else {
            state = .unauthenticated
            return
        }

        do {
            let response: MeResponse = try await client.request(.me)
            currentUser = response.user
            state = .authenticated(response.user)
            AppDelegate.sendPendingDeviceToken()
        } catch {
            KeychainHelper.shared.delete(key: "auth_token")
            currentUser = nil
            state = .unauthenticated
        }
    }

    func login(token: String, user: User) {
        KeychainHelper.shared.save(key: "auth_token", value: token)
        currentUser = user
        state = .authenticated(user)
        AppDelegate.sendPendingDeviceToken()
    }

    func logout() async {
        if let deviceToken = UserDefaults.standard.string(forKey: "deviceToken") {
            try? await client.requestVoid(.unregisterDevice(token: deviceToken))
            UserDefaults.standard.removeObject(forKey: "deviceToken")
        }
        try? await client.requestVoid(.logout)
        KeychainHelper.shared.delete(key: "auth_token")
        currentUser = nil
        state = .unauthenticated
    }

    func refreshUser() async {
        do {
            let response: MeResponse = try await client.request(.me)
            currentUser = response.user
            state = .authenticated(response.user)
        } catch {
            // Keep current state on refresh failure
        }
    }

    private func handleSessionExpired() {
        KeychainHelper.shared.delete(key: "auth_token")
        currentUser = nil
        state = .unauthenticated
    }
}
