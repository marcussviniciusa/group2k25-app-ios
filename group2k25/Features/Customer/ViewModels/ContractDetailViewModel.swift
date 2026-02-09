import Foundation
import Observation

@Observable
@MainActor
final class ContractDetailViewModel {
    var contract: Contract?
    var isLoading = false
    var errorMessage: String?

    let contractId: String

    init(contractId: String) {
        self.contractId = contractId
    }

    var installments: [Installment] {
        contract?.installments ?? []
    }

    var paidCount: Int {
        installments.filter { $0.status == .pago }.count
    }

    var progress: Double {
        guard !installments.isEmpty else { return 0 }
        return Double(paidCount) / Double(installments.count)
    }

    func loadContract() async {
        isLoading = true
        errorMessage = nil

        do {
            contract = try await APIClient.shared.request(.contractDetail(id: contractId))
        } catch let error as APIError {
            errorMessage = error.errorDescription
        } catch {
            errorMessage = "Erro ao carregar contrato."
        }

        isLoading = false
    }
}
