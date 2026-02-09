import Foundation

nonisolated enum LeadStatus: String, Codable, Sendable, CaseIterable {
    case novo = "NOVO"
    case aguardandoGanhos = "AGUARDANDO_GANHOS"
    case ganhosRecebidos = "GANHOS_RECEBIDOS"
    case ganhosAprovados = "GANHOS_APROVADOS"
    case ganhosRejeitados = "GANHOS_REJEITADOS"
    case aguardandoAceite = "AGUARDANDO_ACEITE"
    case propostaAceita = "PROPOSTA_ACEITA"
    case aguardandoDocumentos = "AGUARDANDO_DOCUMENTOS"
    case documentosRecebidos = "DOCUMENTOS_RECEBIDOS"
    case documentosAprovados = "DOCUMENTOS_APROVADOS"
    case documentosRejeitados = "DOCUMENTOS_REJEITADOS"
    case convertido = "CONVERTIDO"
    case rejeitado = "REJEITADO"

    var displayName: String {
        switch self {
        case .novo: return "Novo"
        case .aguardandoGanhos: return "Aguardando Ganhos"
        case .ganhosRecebidos: return "Ganhos Recebidos"
        case .ganhosAprovados: return "Ganhos Aprovados"
        case .ganhosRejeitados: return "Ganhos Rejeitados"
        case .aguardandoAceite: return "Aguardando Aceite"
        case .propostaAceita: return "Proposta Aceita"
        case .aguardandoDocumentos: return "Aguardando Documentos"
        case .documentosRecebidos: return "Documentos Recebidos"
        case .documentosAprovados: return "Documentos Aprovados"
        case .documentosRejeitados: return "Documentos Rejeitados"
        case .convertido: return "Convertido"
        case .rejeitado: return "Rejeitado"
        }
    }
}

nonisolated enum DocumentType: String, Codable, Sendable {
    case cnh
    case addressProof
    case uberProfile
}

nonisolated struct LeadDocument: Codable, Sendable {
    let type: DocumentType
    let status: String?
    let uploadedAt: Date?
}

nonisolated struct Lead: Codable, Sendable, Identifiable {
    let id: String
    let phone: String
    let name: String?
    let status: LeadStatus
    let weeklyEarnings: Decimal?
    let documents: [LeadDocument]?
    let createdAt: Date?
    let updatedAt: Date?
}
