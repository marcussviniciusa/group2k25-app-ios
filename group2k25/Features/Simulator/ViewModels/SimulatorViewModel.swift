import Foundation
import Observation

@Observable
@MainActor
final class SimulatorViewModel {
    var weeklyEarnings: String = ""
    var isLoading = false
    var errorMessage: String?
    var result: SimulatorResult?

    var earningsDecimal: Decimal? {
        let clean = weeklyEarnings.replacingOccurrences(of: ".", with: "").replacingOccurrences(of: ",", with: ".")
        return Decimal(string: clean)
    }

    var isValid: Bool {
        guard let value = earningsDecimal else { return false }
        return value >= 100
    }

    func simulate() async {
        guard let value = earningsDecimal else {
            errorMessage = "Informe seus ganhos semanais (mínimo R$ 100,00)."
            return
        }

        guard value >= 100 else {
            errorMessage = "O valor mínimo é R$ 100,00 por semana."
            return
        }

        isLoading = true
        errorMessage = nil

        do {
            result = try await APIClient.shared.request(.simulate(weeklyEarnings: value))
        } catch let error as APIError {
            errorMessage = error.errorDescription
        } catch {
            errorMessage = "Erro ao simular. Tente novamente."
        }

        isLoading = false
    }

    func reset() {
        weeklyEarnings = ""
        result = nil
        errorMessage = nil
    }
}
