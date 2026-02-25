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

                    Image(systemName: vm.loginMode == .password ? "lock.fill" : "iphone.and.arrow.forward")
                        .font(.system(size: 56))
                        .foregroundStyle(AppTheme.primaryGradient)

                    VStack(spacing: AppTheme.smallSpacing) {
                        Text("Entrar")
                            .font(.largeTitle.bold())
                            .foregroundStyle(.primary)
                        Text(vm.loginMode == .password
                             ? "Informe seu celular e senha para acessar sua conta."
                             : "Informe seu número de celular para receber o código de verificação via WhatsApp.")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                    }

                    PhoneTextField(phone: $vm.phone)

                    if vm.loginMode == .password {
                        SecureField("Senha", text: $vm.password)
                            .textContentType(.password)
                            .padding()
                            .background(.ultraThinMaterial)
                            .clipShape(RoundedRectangle(cornerRadius: AppTheme.cornerRadius))
                    }

                    if let error = vm.errorMessage {
                        Text(error)
                            .font(.caption)
                            .foregroundStyle(.appDanger)
                            .multilineTextAlignment(.center)
                    }

                    if vm.loginMode == .password {
                        PrimaryButton(
                            title: "Entrar",
                            isLoading: vm.isLoading,
                            isDisabled: !vm.isPhoneValid || !vm.isPasswordValid
                        ) {
                            Task { await vm.loginWithPassword(authManager: authManager) }
                        }
                    } else {
                        PrimaryButton(
                            title: "Enviar código",
                            isLoading: vm.isLoading,
                            isDisabled: !vm.isPhoneValid
                        ) {
                            Task { await vm.sendOTP() }
                        }
                    }

                    // Toggle between modes
                    Button {
                        withAnimation {
                            vm.errorMessage = nil
                            vm.loginMode = vm.loginMode == .password ? .otp : .password
                        }
                    } label: {
                        Text(vm.loginMode == .password
                             ? "Entrar com código WhatsApp"
                             : "Entrar com senha")
                            .font(.subheadline.weight(.medium))
                            .foregroundStyle(.appPrimary)
                    }

                    if vm.loginMode == .password {
                        Button {
                            if let url = URL(string: "https://group2k25.com.br/entrar") {
                                UIApplication.shared.open(url)
                            }
                        } label: {
                            Text("Não tem senha? Crie no site")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
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
