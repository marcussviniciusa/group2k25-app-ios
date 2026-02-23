import Foundation

nonisolated struct APIEndpoint: Sendable {
    let path: String
    let method: HTTPMethod
    let requiresAuth: Bool
    let body: Data?
    let queryItems: [URLQueryItem]?

    nonisolated enum HTTPMethod: String, Sendable {
        case GET, POST, PUT, DELETE
    }

    init(
        path: String,
        method: HTTPMethod = .GET,
        requiresAuth: Bool = false,
        body: Data? = nil,
        queryItems: [URLQueryItem]? = nil
    ) {
        self.path = path
        self.method = method
        self.requiresAuth = requiresAuth
        self.body = body
        self.queryItems = queryItems
    }

    var url: URL {
        var components = URLComponents(url: APIConfiguration.baseURL.appendingPathComponent(path), resolvingAgainstBaseURL: true)!
        components.queryItems = queryItems
        return components.url!
    }

    // MARK: - Auth

    static func sendOTP(phone: String) -> APIEndpoint {
        let body = try? JSONEncoder().encode(["phone": phone])
        return APIEndpoint(path: "/auth/send-otp", method: .POST, body: body)
    }

    static func verifyOTP(phone: String, code: String) -> APIEndpoint {
        let body = try? JSONEncoder().encode(["phone": phone, "code": code])
        return APIEndpoint(path: "/auth/verify-otp", method: .POST, body: body)
    }

    static var me: APIEndpoint {
        APIEndpoint(path: "/auth/me", requiresAuth: true)
    }

    static var logout: APIEndpoint {
        APIEndpoint(path: "/auth/logout", method: .POST, requiresAuth: true)
    }

    // MARK: - Config

    static var pixKey: APIEndpoint {
        APIEndpoint(path: "/config/pix")
    }

    // MARK: - Contracts

    static var contracts: APIEndpoint {
        APIEndpoint(path: "/contracts", requiresAuth: true)
    }

    static func contractDetail(id: String) -> APIEndpoint {
        APIEndpoint(path: "/contracts/\(id)", requiresAuth: true)
    }

    // MARK: - Installments

    static func installments(status: String? = nil) -> APIEndpoint {
        var items: [URLQueryItem]? = nil
        if let status {
            items = [URLQueryItem(name: "status", value: status)]
        }
        return APIEndpoint(path: "/installments", requiresAuth: true, queryItems: items)
    }

    // MARK: - Devices

    static func registerDevice(token: String) -> APIEndpoint {
        let body = try? JSONEncoder().encode(["token": token, "platform": "ios"])
        return APIEndpoint(path: "/devices", method: .POST, requiresAuth: true, body: body)
    }

    static func unregisterDevice(token: String) -> APIEndpoint {
        let body = try? JSONEncoder().encode(["token": token])
        return APIEndpoint(path: "/devices", method: .DELETE, requiresAuth: true, body: body)
    }
}
