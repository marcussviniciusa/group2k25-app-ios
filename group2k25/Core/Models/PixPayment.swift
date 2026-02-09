import Foundation

nonisolated struct PixPayment: Codable, Sendable {
    let pixCopiaECola: String
    let expiresAt: Date
    let amount: Decimal
    let installmentId: String
}
