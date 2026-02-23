import Foundation
import Observation

nonisolated struct PixKeyResponse: Codable, Sendable {
    let pixKey: String
}

@Observable
@MainActor
final class CustomerHomeViewModel {
    var contracts: [Contract] = []
    var pendingInstallments: [Installment] = []
    var pixKey: String?
    var isLoading = false
    var errorMessage: String?

    var totalDebt: Decimal {
        contracts.filter { $0.status == .aberto }.reduce(0) { $0 + $1.totalAmount }
    }

    var nextInstallment: Installment? {
        pendingInstallments
            .filter { $0.status == .pendente || $0.status == .atrasado }
            .sorted { ($0.dueDate ?? "9999-12-31") < ($1.dueDate ?? "9999-12-31") }
            .first
    }

    var overdueCount: Int {
        pendingInstallments.filter { $0.status == .atrasado }.count
    }

    func loadDashboard() async {
        isLoading = true
        errorMessage = nil

        do {
            async let contractsResult: [Contract] = APIClient.shared.request(.contracts)
            async let installmentsResult: [Installment] = APIClient.shared.request(.installments())
            async let pixResult: PixKeyResponse = APIClient.shared.request(.pixKey)

            contracts = try await contractsResult
            pendingInstallments = try await installmentsResult
            pixKey = try? await pixResult.pixKey
        } catch let error as APIError {
            errorMessage = error.errorDescription
        } catch {
            errorMessage = "Erro ao carregar dados."
        }

        isLoading = false
    }
}
