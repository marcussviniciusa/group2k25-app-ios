import SwiftUI

struct LeadStatusBadge: View {
    let status: LeadStatus

    var color: Color {
        switch status {
        case .novo, .aguardandoGanhos:
            return .appAccent
        case .ganhosRecebidos, .ganhosAprovados, .propostaAceita, .documentosRecebidos, .documentosAprovados:
            return .appWarning
        case .aguardandoAceite, .aguardandoDocumentos:
            return .appPrimary
        case .convertido:
            return .appSuccess
        case .ganhosRejeitados, .documentosRejeitados, .rejeitado:
            return .appDanger
        }
    }

    var body: some View {
        StatusBadge(text: status.displayName, color: color)
    }
}
