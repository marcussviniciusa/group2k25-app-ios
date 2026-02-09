import Foundation
import Observation

@Observable
@MainActor
final class LoginViewModel {
    var phone: String = ""
    var isLoading = false
    var errorMessage: String?
    var otpSent = false

    var cleanPhone: String {
        phone.digitsOnly
    }

    var isPhoneValid: Bool {
        cleanPhone.count == 11
    }

    func sendOTP() async {
        guard isPhoneValid else {
            errorMessage = "Informe um número de celular válido."
            return
        }

        isLoading = true
        errorMessage = nil

        do {
            let _: OTPSendResponse = try await APIClient.shared.request(.sendOTP(phone: cleanPhone))
            otpSent = true
        } catch let error as APIError {
            errorMessage = error.errorDescription
        } catch {
            errorMessage = "Erro inesperado. Tente novamente."
        }

        isLoading = false
    }
}
