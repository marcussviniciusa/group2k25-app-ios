import Foundation

nonisolated enum ContractStatus: String, Codable, Sendable {
    case aberto = "ABERTO"
    case quitado = "QUITADO"
    case atrasado = "ATRASADO"
    case cancelado = "CANCELADO"
    case renegociado = "RENEGOCIADO"

    var displayName: String {
        switch self {
        case .aberto: return "Ativo"
        case .quitado: return "Quitado"
        case .atrasado: return "Inadimplente"
        case .cancelado: return "Cancelado"
        case .renegociado: return "Renegociado"
        }
    }
}

nonisolated struct Contract: Codable, Sendable, Identifiable {
    let id: String
    let number: Int?
    let principalAmount: Decimal
    let totalAmount: Decimal
    let interestRate: Decimal
    let installmentsCount: Int
    let installmentAmount: Decimal
    let status: ContractStatus
    let paidCount: Int?
    let overdueCount: Int?
    let remainingAmount: Decimal?
    let nextDueDate: String?
    let createdAt: String?
    let installments: [Installment]?

    var loanAmount: Decimal { principalAmount }
    var numberOfInstallments: Int { installmentsCount }

    var createdAtFormatted: String {
        guard let createdAt else { return "-" }
        let iso = ISO8601DateFormatter()
        iso.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        guard let date = iso.date(from: createdAt) else { return createdAt }
        return date.asBrazilianDate
    }

    var nextDueDateFormatted: String {
        guard let nextDueDate else { return "-" }
        let iso = ISO8601DateFormatter()
        iso.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        guard let date = iso.date(from: nextDueDate) else { return nextDueDate }
        return date.asBrazilianDate
    }
}

nonisolated struct ContractDetailResponse: Codable, Sendable {
    let contract: Contract
    let installments: [Installment]
}
