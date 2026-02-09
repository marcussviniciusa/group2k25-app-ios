import Foundation
import Observation
import PhotosUI
import SwiftUI

@Observable
@MainActor
final class EarningsUploadViewModel {
    var selectedItem: PhotosPickerItem?
    var imageData: Data?
    var isLoading = false
    var errorMessage: String?
    var uploadSuccess = false

    func processSelectedPhoto() async {
        guard let item = selectedItem else { return }

        do {
            if let data = try await item.loadTransferable(type: Data.self) {
                imageData = data
            }
        } catch {
            errorMessage = "Erro ao carregar a imagem."
        }
    }

    func upload() async {
        guard let data = imageData else {
            errorMessage = "Selecione uma imagem do relatório de ganhos."
            return
        }

        isLoading = true
        errorMessage = nil

        let base64 = data.base64EncodedString()
        let fileName = "earnings_\(Date().timeIntervalSince1970).jpg"

        do {
            let _: DocumentUploadResponse = try await APIClient.shared.request(
                .uploadEarnings(fileBase64: base64, fileName: fileName)
            )
            uploadSuccess = true
        } catch let error as APIError {
            errorMessage = error.errorDescription
        } catch {
            errorMessage = "Erro ao enviar relatório."
        }

        isLoading = false
    }
}
