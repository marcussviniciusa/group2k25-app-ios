import Foundation
import os

private let logger = Logger(subsystem: "com.group2k25", category: "APIClient")

nonisolated struct APIResponse<T: Decodable>: Decodable {
    let data: T?
    let message: String?
    let error: String?
}

final class APIClient: Sendable {
    static let shared = APIClient()

    private let session: URLSession
    private let decoder: JSONDecoder

    private init() {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 30
        config.requestCachePolicy = .reloadIgnoringLocalCacheData
        config.urlCache = nil
        self.session = URLSession(configuration: config)
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        self.decoder = decoder
    }

    func request<T: Decodable & Sendable>(_ endpoint: APIEndpoint) async throws -> T {
        var request = URLRequest(url: endpoint.url)
        request.httpMethod = endpoint.method.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        if endpoint.requiresAuth {
            guard let token = KeychainHelper.shared.read(key: "auth_token") else {
                throw APIError.unauthorized
            }
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }

        if let body = endpoint.body {
            request.httpBody = body
        }

        let data: Data
        let response: URLResponse

        do {
            (data, response) = try await session.data(for: request)
        } catch {
            throw APIError.networkError(error.localizedDescription)
        }

        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }

        switch httpResponse.statusCode {
        case 200...299:
            break
        case 401:
            await MainActor.run {
                NotificationCenter.default.post(name: .authSessionExpired, object: nil)
            }
            throw APIError.unauthorized
        case 403:
            throw APIError.forbidden
        case 404:
            throw APIError.notFound
        case 422:
            if let apiResponse = try? decoder.decode(APIResponse<EmptyResponse>.self, from: data),
               let message = apiResponse.error ?? apiResponse.message {
                throw APIError.validationError(message)
            }
            throw APIError.validationError("Dados inválidos.")
        default:
            throw APIError.serverError(statusCode: httpResponse.statusCode)
        }

        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            let json = String(data: data, encoding: .utf8) ?? "nil"
            logger.error("Decode error for \(String(describing: T.self)) at \(endpoint.path)")
            logger.error("JSON: \(json)")
            logger.error("Error: \(error)")
            throw APIError.decodingError(error.localizedDescription)
        }
    }

    func requestVoid(_ endpoint: APIEndpoint) async throws {
        var request = URLRequest(url: endpoint.url)
        request.httpMethod = endpoint.method.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        if endpoint.requiresAuth {
            guard let token = KeychainHelper.shared.read(key: "auth_token") else {
                throw APIError.unauthorized
            }
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }

        if let body = endpoint.body {
            request.httpBody = body
        }

        let data: Data
        let response: URLResponse

        do {
            (data, response) = try await session.data(for: request)
        } catch {
            throw APIError.networkError(error.localizedDescription)
        }

        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }

        switch httpResponse.statusCode {
        case 200...299:
            return
        case 401:
            await MainActor.run {
                NotificationCenter.default.post(name: .authSessionExpired, object: nil)
            }
            throw APIError.unauthorized
        case 403:
            throw APIError.forbidden
        case 404:
            throw APIError.notFound
        case 422:
            if let apiResponse = try? decoder.decode(APIResponse<EmptyResponse>.self, from: data),
               let message = apiResponse.error ?? apiResponse.message {
                throw APIError.validationError(message)
            }
            throw APIError.validationError("Dados inválidos.")
        default:
            throw APIError.serverError(statusCode: httpResponse.statusCode)
        }
    }
}

nonisolated struct EmptyResponse: Decodable, Sendable {}

extension Notification.Name {
    static let authSessionExpired = Notification.Name("authSessionExpired")
}
