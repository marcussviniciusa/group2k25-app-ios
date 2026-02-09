import SwiftUI

struct PixPaymentView: View {
    @State private var vm: PixPaymentViewModel

    init(installmentId: String) {
        _vm = State(initialValue: PixPaymentViewModel(installmentId: installmentId))
    }

    var body: some View {
        ZStack {
            GradientBackground()

            if vm.isLoading && vm.pixPayment == nil {
                LoadingView(message: "Gerando PIX...")
            } else if let error = vm.errorMessage, vm.pixPayment == nil {
                ErrorView(message: error) {
                    Task { await vm.generatePix() }
                }
            } else if let pix = vm.pixPayment {
                pixContent(pix)
            }
        }
        .navigationTitle("Pagamento PIX")
        .navigationBarTitleDisplayMode(.inline)
        .task { await vm.generatePix() }
    }

    private func pixContent(_ pix: PixPayment) -> some View {
        ScrollView {
            VStack(spacing: AppTheme.largeSpacing) {
                Image(systemName: "qrcode")
                    .font(.system(size: 64))
                    .foregroundStyle(AppTheme.primaryGradient)

                CurrencyText(amount: pix.amount, font: .largeTitle.bold(), color: .appSuccess)

                PixTimerView(expiresAt: pix.expiresAt) {
                    vm.isExpired = true
                }

                pixCodeCard(pix)

                if vm.isExpired {
                    expiredSection
                } else {
                    copyButton
                }

                instructionsCard
            }
            .padding(AppTheme.spacing)
        }
    }

    private func pixCodeCard(_ pix: PixPayment) -> some View {
        GlassCard {
            VStack(spacing: AppTheme.smallSpacing) {
                Text("PIX Copia e Cola")
                    .font(.headline)
                    .foregroundStyle(.primary)
                Text(pix.pixCopiaECola)
                    .font(.system(.caption, design: .monospaced))
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .lineLimit(4)
                    .textSelection(.enabled)
            }
        }
    }

    private var copyButton: some View {
        PrimaryButton(title: vm.copied ? "Copiado!" : "Copiar código PIX") {
            vm.copyToClipboard()
        }
    }

    private var expiredSection: some View {
        VStack(spacing: AppTheme.spacing) {
            GlassCard {
                VStack(spacing: AppTheme.smallSpacing) {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .font(.title2)
                        .foregroundStyle(.appWarning)
                    Text("Este PIX expirou")
                        .font(.headline)
                        .foregroundStyle(.primary)
                    Text("Gere um novo código para realizar o pagamento.")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }

            PrimaryButton(title: "Gerar novo PIX", isLoading: vm.isLoading) {
                Task { await vm.generatePix() }
            }
        }
    }

    private var instructionsCard: some View {
        GlassCard {
            VStack(alignment: .leading, spacing: AppTheme.smallSpacing) {
                Label("Como pagar", systemImage: "info.circle.fill")
                    .font(.headline)
                    .foregroundStyle(.appAccent)
                Text("1. Copie o código PIX acima")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Text("2. Abra o app do seu banco")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Text("3. Escolha pagar via PIX Copia e Cola")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Text("4. Cole o código e confirme o pagamento")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
    }
}
