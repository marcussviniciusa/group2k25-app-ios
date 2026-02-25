import Foundation

nonisolated struct OTPSendResponse: Codable, Sendable {
    let success: Bool
    let message: String
    let expiresIn: Int?
}

nonisolated struct OTPVerifyResponse: Codable, Sendable {
    let success: Bool
    let token: String
    let user: User
}

nonisolated struct HasPasswordResponse: Codable, Sendable {
    let hasPassword: Bool
}
