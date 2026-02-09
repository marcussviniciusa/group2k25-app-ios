import Foundation
import Observation

@Observable
@MainActor
final class LeadHomeViewModel {
    var lead: Lead?
    var isLoading = false
    var errorMessage: String?

    func loadLead() async {
        isLoading = true
        errorMessage = nil

        do {
            lead = try await APIClient.shared.request(.lead)
        } catch let error as APIError {
            errorMessage = error.errorDescription
        } catch {
            errorMessage = "Erro ao carregar dados."
        }

        isLoading = false
    }
}
