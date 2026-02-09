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

    // MARK: - Simulator

    static func simulate(weeklyEarnings: Decimal) -> APIEndpoint {
        let body = try? JSONSerialization.data(withJSONObject: ["weeklyEarnings": NSDecimalNumber(decimal: weeklyEarnings).doubleValue])
        return APIEndpoint(path: "/simulator", method: .POST, body: body)
    }

    // MARK: - Lead

    static var lead: APIEndpoint {
        APIEndpoint(path: "/lead", requiresAuth: true)
    }

    static func uploadEarnings(fileBase64: String, fileName: String) -> APIEndpoint {
        let body = try? JSONEncoder().encode(["file": fileBase64, "fileName": fileName])
        return APIEndpoint(path: "/lead/earnings", method: .POST, requiresAuth: true, body: body)
    }

    static var proposal: APIEndpoint {
        APIEndpoint(path: "/lead/proposal", requiresAuth: true)
    }

    static var acceptProposal: APIEndpoint {
        APIEndpoint(path: "/lead/accept", method: .POST, requiresAuth: true)
    }

    static func uploadDocuments(cnh: String?, addressProof: String?, uberProfile: String?) -> APIEndpoint {
        var dict: [String: String] = [:]
        if let cnh { dict["cnh"] = cnh }
        if let addressProof { dict["addressProof"] = addressProof }
        if let uberProfile { dict["uberProfile"] = uberProfile }
        let body = try? JSONEncoder().encode(dict)
        return APIEndpoint(path: "/lead/documents", method: .POST, requiresAuth: true, body: body)
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

    static func generatePix(installmentId: String) -> APIEndpoint {
        APIEndpoint(path: "/installments/\(installmentId)/pix", method: .POST, requiresAuth: true)
    }
}
