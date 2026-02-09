import SwiftUI

struct LoginView: View {
    @State private var vm = LoginViewModel()
    @Environment(AuthManager.self) private var authManager
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack {
            GradientBackground()

            ScrollView {
                VStack(spacing: AppTheme.largeSpacing) {
                    Spacer().frame(height: 40)

                    Image(systemName: "iphone.and.arrow.forward")
                        .font(.system(size: 56))
                        .foregroundStyle(AppTheme.primaryGradient)

                    VStack(spacing: AppTheme.smallSpacing) {
                        Text("Entrar")
                            .font(.largeTitle.bold())
                            .foregroundStyle(.primary)
                        Text("Informe seu número de celular para receber o código de verificação via WhatsApp.")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                    }

                    PhoneTextField(phone: $vm.phone)

                    if let error = vm.errorMessage {
                        Text(error)
                            .font(.caption)
                            .foregroundStyle(.appDanger)
                            .multilineTextAlignment(.center)
                    }

                    PrimaryButton(
                        title: "Enviar código",
                        isLoading: vm.isLoading,
                        isDisabled: !vm.isPhoneValid
                    ) {
                        Task { await vm.sendOTP() }
                    }
                }
                .padding(AppTheme.largeSpacing)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationDestination(isPresented: $vm.otpSent) {
            OTPVerificationView(phone: vm.cleanPhone)
        }
    }
}
