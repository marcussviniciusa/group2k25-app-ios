import Foundation
import Observation
import UIKit

@Observable
@MainActor
final class PixPaymentViewModel {
    var pixPayment: PixPayment?
    var isLoading = false
    var errorMessage: String?
    var copied = false
    var isExpired = false

    let installmentId: String

    init(installmentId: String) {
        self.installmentId = installmentId
    }

    func generatePix() async {
        isLoading = true
        errorMessage = nil
        isExpired = false

        do {
            pixPayment = try await APIClient.shared.request(.generatePix(installmentId: installmentId))
        } catch let error as APIError {
            errorMessage = error.errorDescription
        } catch {
            errorMessage = "Erro ao gerar PIX."
        }

        isLoading = false
    }

    func copyToClipboard() {
        guard let pix = pixPayment?.pixCopiaECola else { return }
        UIPasteboard.general.string = pix
        copied = true

        Task {
            try? await Task.sleep(for: .seconds(3))
            copied = false
        }
    }

    func checkExpiration() {
        guard let expiresAt = pixPayment?.expiresAt else { return }
        isExpired = expiresAt <= Date()
    }
}
