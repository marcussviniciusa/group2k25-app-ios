import Foundation
import Observation

@Observable
@MainActor
final class OnboardingViewModel {
    var weeklyEarnings: String = ""
    var isLoading = false
    var errorMessage: String?
    var simulatorResult: SimulatorResult?

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
            errorMessage = "Informe seus ganhos semanais."
            return
        }

        isLoading = true
        errorMessage = nil

        do {
            let result: SimulatorResult = try await APIClient.shared.request(.simulate(weeklyEarnings: value))
            simulatorResult = result
        } catch let error as APIError {
            errorMessage = error.errorDescription
        } catch {
            errorMessage = "Erro ao simular. Tente novamente."
        }

        isLoading = false
    }
}
