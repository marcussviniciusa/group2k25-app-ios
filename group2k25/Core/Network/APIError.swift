import Foundation

nonisolated enum APIError: LocalizedError, Sendable {
    case invalidURL
    case invalidResponse
    case unauthorized
    case forbidden
    case notFound
    case serverError(statusCode: Int)
    case decodingError(String)
    case networkError(String)
    case validationError(String)
    case unknown(String)

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "URL inválida."
        case .invalidResponse:
            return "Resposta inválida do servidor."
        case .unauthorized:
            return "Sessão expirada. Faça login novamente."
        case .forbidden:
            return "Você não tem permissão para acessar este recurso."
        case .notFound:
            return "Recurso não encontrado."
        case .serverError(let statusCode):
            return "Erro no servidor (\(statusCode)). Tente novamente mais tarde."
        case .decodingError(let detail):
            return "Erro ao processar dados: \(detail)"
        case .networkError(let detail):
            return "Erro de conexão: \(detail)"
        case .validationError(let message):
            return message
        case .unknown(let message):
            return message
        }
    }
}
