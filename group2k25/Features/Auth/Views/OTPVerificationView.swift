import SwiftUI

struct OTPVerificationView: View {
    @State private var vm: OTPViewModel
    @Environment(AuthManager.self) private var authManager

    init(phone: String) {
        _vm = State(initialValue: OTPViewModel(phone: phone))
    }

    var body: some View {
        ZStack {
            GradientBackground()

            ScrollView {
                VStack(spacing: AppTheme.largeSpacing) {
                    Spacer().frame(height: 40)

                    Image(systemName: "lock.shield.fill")
                        .font(.system(size: 56))
                        .foregroundStyle(AppTheme.primaryGradient)

                    VStack(spacing: AppTheme.smallSpacing) {
                        Text("Verificação")
                            .font(.largeTitle.bold())
                            .foregroundStyle(.primary)
                        Text("Digite o código de 6 dígitos enviado para o seu WhatsApp.")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                    }

                    otpField

                    if let error = vm.errorMessage {
                        Text(error)
                            .font(.caption)
                            .foregroundStyle(.appDanger)
                            .multilineTextAlignment(.center)
                    }

                    PrimaryButton(
                        title: "Verificar",
                        isLoading: vm.isLoading,
                        isDisabled: !vm.isCodeValid
                    ) {
                        Task { await vm.verifyOTP(authManager: authManager) }
                    }

                    resendSection
                }
                .padding(AppTheme.largeSpacing)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .onAppear { vm.startCountdown() }
        .onDisappear { vm.cleanup() }
    }

    private var otpField: some View {
        TextField("000000", text: $vm.code)
            .keyboardType(.numberPad)
            .textContentType(.oneTimeCode)
            .multilineTextAlignment(.center)
            .font(.system(size: 32, weight: .bold, design: .monospaced))
            .padding()
            .background(Color.appSurface)
            .clipShape(RoundedRectangle(cornerRadius: AppTheme.buttonCornerRadius))
            .overlay(
                RoundedRectangle(cornerRadius: AppTheme.buttonCornerRadius)
                    .stroke(Color.white.opacity(0.1), lineWidth: 1)
            )
            .onChange(of: vm.code) { _, newValue in
                vm.code = String(newValue.digitsOnly.prefix(6))
            }
    }

    private var resendSection: some View {
        VStack(spacing: AppTheme.smallSpacing) {
            if vm.canResend {
                Button("Reenviar código") {
                    Task { await vm.resendOTP() }
                }
                .foregroundStyle(.appAccent)
                .font(.subheadline.bold())
            } else {
                Text("Reenviar em \(vm.remainingSeconds)s")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
    }
}
