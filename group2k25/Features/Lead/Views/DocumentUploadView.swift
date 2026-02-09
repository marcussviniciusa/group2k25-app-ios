import SwiftUI
import PhotosUI

struct DocumentUploadView: View {
    @State private var vm = DocumentUploadViewModel()
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack {
            GradientBackground()

            ScrollView {
                VStack(spacing: AppTheme.largeSpacing) {
                    headerSection
                    documentPickers
                    if let error = vm.errorMessage {
                        Text(error)
                            .font(.caption)
                            .foregroundStyle(.appDanger)
                    }
                    PrimaryButton(
                        title: "Enviar documentos",
                        isLoading: vm.isLoading,
                        isDisabled: !vm.canUpload
                    ) {
                        Task { await vm.uploadAll() }
                    }
                }
                .padding(AppTheme.spacing)
            }
        }
        .navigationTitle("Documentos")
        .navigationBarTitleDisplayMode(.inline)
        .withLoading(vm.isLoading)
        .onChange(of: vm.cnhItem) { _, _ in
            Task { await vm.processPhoto(item: vm.cnhItem, type: .cnh) }
        }
        .onChange(of: vm.addressItem) { _, _ in
            Task { await vm.processPhoto(item: vm.addressItem, type: .addressProof) }
        }
        .onChange(of: vm.uberItem) { _, _ in
            Task { await vm.processPhoto(item: vm.uberItem, type: .uberProfile) }
        }
        .onChange(of: vm.uploadSuccess) { _, success in
            if success { dismiss() }
        }
    }

    private var headerSection: some View {
        VStack(spacing: AppTheme.smallSpacing) {
            Image(systemName: "doc.badge.plus")
                .font(.system(size: 48))
                .foregroundStyle(AppTheme.primaryGradient)
            Text("Envie seus documentos")
                .font(.title3.bold())
            Text("Precisamos de 3 documentos para finalizar sua solicitação.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
    }

    private var documentPickers: some View {
        VStack(spacing: AppTheme.spacing) {
            documentPickerCard(
                title: "CNH",
                description: "Carteira Nacional de Habilitação (frente e verso)",
                icon: "person.text.rectangle",
                selection: $vm.cnhItem,
                hasImage: vm.cnhData != nil
            )
            documentPickerCard(
                title: "Comprovante de Endereço",
                description: "Conta de luz, água ou telefone (últimos 3 meses)",
                icon: "house.fill",
                selection: $vm.addressItem,
                hasImage: vm.addressData != nil
            )
            documentPickerCard(
                title: "Perfil Uber",
                description: "Captura de tela do seu perfil no app Uber Driver",
                icon: "car.fill",
                selection: $vm.uberItem,
                hasImage: vm.uberData != nil
            )
        }
    }

    private func documentPickerCard(
        title: String,
        description: String,
        icon: String,
        selection: Binding<PhotosPickerItem?>,
        hasImage: Bool
    ) -> some View {
        PhotosPicker(selection: selection, matching: .images) {
            GlassCard {
                HStack(spacing: AppTheme.spacing) {
                    Image(systemName: hasImage ? "checkmark.circle.fill" : icon)
                        .font(.title2)
                        .foregroundStyle(hasImage ? Color.appSuccess : .appPrimary)
                        .frame(width: 40)
                    VStack(alignment: .leading, spacing: 2) {
                        Text(title)
                            .font(.headline)
                            .foregroundStyle(.primary)
                        Text(hasImage ? "Documento selecionado" : description)
                            .font(.caption)
                            .foregroundStyle(hasImage ? Color.appSuccess : .secondary)
                    }
                    Spacer()
                    Image(systemName: "photo.badge.plus")
                        .foregroundStyle(.secondary)
                }
            }
        }
    }
}
