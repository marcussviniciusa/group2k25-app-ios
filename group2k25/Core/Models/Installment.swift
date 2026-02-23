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

    var dueDateFormatted: String {
        guard let dueDate else { return "-" }
        let iso = ISO8601DateFormatter()
        iso.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        guard let date = iso.date(from: dueDate) else { return dueDate }
        return date.asBrazilianDate
    }

    var paidAtFormatted: String {
        guard let paidAt else { return "-" }
        let iso = ISO8601DateFormatter()
        iso.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        guard let date = iso.date(from: paidAt) else { return paidAt }
        return date.asBrazilianDate
    }
}
