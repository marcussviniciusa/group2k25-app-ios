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
            let response: ContractDetailResponse = try await APIClient.shared.request(.contractDetail(id: contractId))
            var detail = response.contract
            detail = Contract(
                id: detail.id,
                number: detail.number,
                principalAmount: detail.principalAmount,
                totalAmount: detail.totalAmount,
                interestRate: detail.interestRate,
                installmentsCount: detail.installmentsCount,
                installmentAmount: detail.installmentAmount,
                status: detail.status,
                paidCount: detail.paidCount,
                overdueCount: detail.overdueCount,
                remainingAmount: detail.remainingAmount,
                nextDueDate: detail.nextDueDate,
                createdAt: detail.createdAt,
                installments: response.installments
            )
            contract = detail
        } catch let error as APIError {
            errorMessage = error.errorDescription
        } catch {
            errorMessage = "Erro ao carregar contrato."
        }

        isLoading = false
    }
}
