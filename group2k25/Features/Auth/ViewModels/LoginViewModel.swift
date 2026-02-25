import Foundation
import Observation

enum LoginMode {
    case password, otp
}

@Observable
@MainActor
final class LoginViewModel {
    var phone: String = ""
    var password: String = ""
    var loginMode: LoginMode = .password
    var isLoading = false
    var errorMessage: String?
    var otpSent = false

    var cleanPhone: String {
        phone.digitsOnly
    }

    var isPhoneValid: Bool {
        cleanPhone.count == 11
    }

    var isPasswordValid: Bool {
        password.count >= 6
    }

    func loginWithPassword(authManager: AuthManager) async {
        guard isPhoneValid else {
            errorMessage = "Informe um número de celular válido."
            return
        }
        guard isPasswordValid else {
            errorMessage = "A senha deve ter no mínimo 6 caracteres."
            return
        }

        isLoading = true
        errorMessage = nil

        do {
            let response: OTPVerifyResponse = try await APIClient.shared.request(
                .loginWithPassword(phone: cleanPhone, password: password)
            )
            authManager.login(token: response.token, user: response.user)
        } catch let error as APIError {
            errorMessage = error.errorDescription
        } catch {
            errorMessage = "Erro inesperado. Tente novamente."
        }

        isLoading = false
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
