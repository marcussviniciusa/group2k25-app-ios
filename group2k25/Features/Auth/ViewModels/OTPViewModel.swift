import Foundation
import Observation

@Observable
@MainActor
final class OTPViewModel {
    var code: String = ""
    var isLoading = false
    var errorMessage: String?
    var remainingSeconds: Int = 60
    var canResend = false

    let phone: String
    private var timerTask: Task<Void, Never>?

    init(phone: String) {
        self.phone = phone
    }

    var isCodeValid: Bool {
        code.digitsOnly.count == 6
    }

    func startCountdown() {
        remainingSeconds = 60
        canResend = false
        timerTask?.cancel()
        timerTask = Task {
            while remainingSeconds > 0 {
                try? await Task.sleep(for: .seconds(1))
                guard !Task.isCancelled else { return }
                remainingSeconds -= 1
            }
            canResend = true
        }
    }

    func verifyOTP(authManager: AuthManager) async {
        let cleanCode = code.digitsOnly
        guard cleanCode.count == 6 else {
            errorMessage = "Informe o código de 6 dígitos."
            return
        }

        isLoading = true
        errorMessage = nil

        do {
            let response: OTPVerifyResponse = try await APIClient.shared.request(
                .verifyOTP(phone: phone, code: cleanCode)
            )
            authManager.login(token: response.token, user: response.user)
        } catch let error as APIError {
            errorMessage = error.errorDescription
        } catch {
            errorMessage = "Erro inesperado. Tente novamente."
        }

        isLoading = false
    }

    func resendOTP() async {
        guard canResend else { return }

        isLoading = true
        errorMessage = nil

        do {
            let _: OTPSendResponse = try await APIClient.shared.request(.sendOTP(phone: phone))
            startCountdown()
        } catch let error as APIError {
            errorMessage = error.errorDescription
        } catch {
            errorMessage = "Erro ao reenviar código."
        }

        isLoading = false
    }

    func cleanup() {
        timerTask?.cancel()
    }
}
