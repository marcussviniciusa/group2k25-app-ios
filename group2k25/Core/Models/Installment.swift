import Foundation

nonisolated enum InstallmentStatus: String, Codable, Sendable {
    case pendente = "PENDENTE"
    case pago = "PAGO"
    case atrasado = "ATRASADO"
    case parcial = "PARCIAL"
    case cancelado = "CANCELADO"

    var displayName: String {
        switch self {
        case .pendente: return "Pendente"
        case .pago: return "Pago"
        case .atrasado: return "Atrasado"
        case .parcial: return "Parcial"
        case .cancelado: return "Cancelado"
        }
    }
}

nonisolated struct Installment: Codable, Sendable, Identifiable {
    let id: String
    let contractId: String
    let contractNumber: Int?
    let number: Int
    let amount: Decimal
    let dueDate: String?
    let status: InstallmentStatus
    let paidAmount: Decimal?
    let paidAt: String?
    let pixCopiaECola: String?
    let pixExpiresAt: String?

    var dueDateFormatted: String {
        dueDate ?? "-"
    }
}
