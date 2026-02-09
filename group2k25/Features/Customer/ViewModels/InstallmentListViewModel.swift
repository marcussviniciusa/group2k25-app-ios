import Foundation
import Observation

@Observable
@MainActor
final class InstallmentListViewModel {
    var installments: [Installment] = []
    var isLoading = false
    var errorMessage: String?
    var selectedFilter: InstallmentFilter = .all

    enum InstallmentFilter: String, CaseIterable {
        case all = "Todas"
        case pending = "Pendentes"
        case overdue = "Atrasadas"
        case paid = "Pagas"

        var apiValue: String? {
            switch self {
            case .all: return nil
            case .pending: return "pending"
            case .overdue: return "overdue"
            case .paid: return "paid"
            }
        }
    }

    var filteredInstallments: [Installment] {
        installments.sorted { ($0.dueDate ?? "9999-12-31") < ($1.dueDate ?? "9999-12-31") }
    }

    func loadInstallments() async {
        isLoading = true
        errorMessage = nil

        do {
            installments = try await APIClient.shared.request(.installments(status: selectedFilter.apiValue))
        } catch let error as APIError {
            errorMessage = error.errorDescription
        } catch {
            errorMessage = "Erro ao carregar parcelas."
        }

        isLoading = false
    }
}
