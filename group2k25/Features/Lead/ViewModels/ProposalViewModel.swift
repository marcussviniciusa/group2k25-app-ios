import Foundation
import Observation

@Observable
@MainActor
final class ProposalViewModel {
    var proposal: Proposal?
    var isLoading = false
    var isAccepting = false
    var errorMessage: String?
    var accepted = false

    func loadProposal() async {
        isLoading = true
        errorMessage = nil

        do {
            proposal = try await APIClient.shared.request(.proposal)
        } catch let error as APIError {
            errorMessage = error.errorDescription
        } catch {
            errorMessage = "Erro ao carregar proposta."
        }

        isLoading = false
    }

    func acceptProposal() async {
        isAccepting = true
        errorMessage = nil

        do {
            try await APIClient.shared.requestVoid(.acceptProposal)
            accepted = true
        } catch let error as APIError {
            errorMessage = error.errorDescription
        } catch {
            errorMessage = "Erro ao aceitar proposta."
        }

        isAccepting = false
    }
}
