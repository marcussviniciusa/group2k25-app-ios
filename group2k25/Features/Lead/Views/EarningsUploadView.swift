import SwiftUI
import PhotosUI

struct EarningsUploadView: View {
    @State private var vm = EarningsUploadViewModel()
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack {
            GradientBackground()

            ScrollView {
                VStack(spacing: AppTheme.largeSpacing) {
                    headerSection
                    imagePickerSection
                    if let error = vm.errorMessage {
                        Text(error)
                            .font(.caption)
                            .foregroundStyle(.appDanger)
                    }
                    uploadButton
                    instructionsSection
                }
                .padding(AppTheme.spacing)
            }
        }
        .navigationTitle("Relatório de Ganhos")
        .navigationBarTitleDisplayMode(.inline)
        .withLoading(vm.isLoading)
        .onChange(of: vm.selectedItem) { _, _ in
            Task { await vm.processSelectedPhoto() }
        }
        .onChange(of: vm.uploadSuccess) { _, success in
            if success { dismiss() }
        }
    }

    private var headerSection: some View {
        VStack(spacing: AppTheme.smallSpacing) {
            Image(systemName: "doc.text.image")
                .font(.system(size: 48))
                .foregroundStyle(AppTheme.primaryGradient)
            Text("Envie seu relatório de ganhos")
                .font(.title3.bold())
            Text("Faça upload da captura de tela do relatório de ganhos semanais do app Uber.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
    }

    private var imagePickerSection: some View {
        PhotosPicker(selection: $vm.selectedItem, matching: .images) {
            GlassCard {
                VStack(spacing: AppTheme.spacing) {
                    if vm.imageData != nil {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 40))
                            .foregroundStyle(.appSuccess)
                        Text("Imagem selecionada")
                            .font(.headline)
                            .foregroundStyle(.appSuccess)
                        Text("Toque para trocar")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    } else {
                        Image(systemName: "photo.badge.plus")
                            .font(.system(size: 40))
                            .foregroundStyle(.appPrimary)
                        Text("Selecionar imagem")
                            .font(.headline)
                            .foregroundStyle(.primary)
                        Text("Toque para escolher da galeria")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
                .frame(maxWidth: .infinity)
                .frame(height: 160)
            }
        }
    }

    private var uploadButton: some View {
        PrimaryButton(
            title: "Enviar relatório",
            isLoading: vm.isLoading,
            isDisabled: vm.imageData == nil
        ) {
            Task { await vm.upload() }
        }
    }

    private var instructionsSection: some View {
        GlassCard {
            VStack(alignment: .leading, spacing: AppTheme.smallSpacing) {
                Label("Instruções", systemImage: "info.circle.fill")
                    .font(.headline)
                    .foregroundStyle(.appAccent)
                Text("1. Abra o app Uber Driver")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Text("2. Vá em Ganhos > Resumo semanal")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Text("3. Tire um print da tela completa")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Text("4. Selecione a imagem acima")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
    }
}
