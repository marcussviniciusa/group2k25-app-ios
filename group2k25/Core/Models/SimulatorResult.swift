import Foundation

nonisolated struct SimulatorResult: Codable, Sendable {
    let qualified: Bool
    let weeklyEarnings: Decimal
    let maxLoanAmount: Decimal?
    let estimatedInstallment: Decimal?
    let numberOfInstallments: Int?
    let interestRate: Decimal?
    let message: String?
}
