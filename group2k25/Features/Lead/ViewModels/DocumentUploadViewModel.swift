import Foundation
import Observation
import PhotosUI
import SwiftUI

@Observable
@MainActor
final class DocumentUploadViewModel {
    var cnhItem: PhotosPickerItem?
    var addressItem: PhotosPickerItem?
    var uberItem: PhotosPickerItem?

    var cnhData: Data?
    var addressData: Data?
    var uberData: Data?

    var isLoading = false
    var errorMessage: String?
    var uploadSuccess = false

    var canUpload: Bool {
        cnhData != nil && addressData != nil && uberData != nil
    }

    func processPhoto(item: PhotosPickerItem?, type: DocumentType) async {
        guard let item else { return }
        do {
            if let data = try await item.loadTransferable(type: Data.self) {
                switch type {
                case .cnh:
                    cnhData = data
                case .addressProof:
                    addressData = data
                case .uberProfile:
                    uberData = data
                }
            }
        } catch {
            errorMessage = "Erro ao carregar imagem."
        }
    }

    func uploadAll() async {
        guard canUpload else {
            errorMessage = "Selecione os 3 documentos antes de enviar."
            return
        }

        isLoading = true
        errorMessage = nil

        let cnh = cnhData?.base64EncodedString()
        let address = addressData?.base64EncodedString()
        let uber = uberData?.base64EncodedString()

        do {
            let _: DocumentUploadResponse = try await APIClient.shared.request(
                .uploadDocuments(cnh: cnh, addressProof: address, uberProfile: uber)
            )
            uploadSuccess = true
        } catch let error as APIError {
            errorMessage = error.errorDescription
        } catch {
            errorMessage = "Erro ao enviar documentos."
        }

        isLoading = false
    }
}
