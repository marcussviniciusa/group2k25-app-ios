import Foundation

nonisolated struct Proposal: Codable, Sendable, Identifiable {
    let id: String
    let leadId: String
    let loanAmount: Decimal
    let numberOfInstallments: Int
    let installmentAmount: Decimal
    let interestRate: Decimal
    let totalAmount: Decimal
    let status: String?
    let createdAt: Date?
    let expiresAt: Date?
}
