import Foundation
import Observation

@Observable
@MainActor
final class ContractListViewModel {
    var contracts: [Contract] = []
    var isLoading = false
    var errorMessage: String?

    func loadContracts() async {
        isLoading = true
        errorMessage = nil

        do {
            contracts = try await APIClient.shared.request(.contracts)
        } catch let error as APIError {
            errorMessage = error.errorDescription
        } catch {
            errorMessage = "Erro ao carregar contratos."
        }

        isLoading = false
    }
}
