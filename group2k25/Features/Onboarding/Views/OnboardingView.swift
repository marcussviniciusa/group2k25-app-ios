import SwiftUI

struct OnboardingView: View {
    @State private var vm = OnboardingViewModel()
    @State private var showLogin = false
    @State private var showSimulatorResult = false

    var body: some View {
        NavigationStack {
            ZStack {
                GradientBackground()

                ScrollView {
                    VStack(spacing: AppTheme.largeSpacing) {
                        heroSection
                        featuresSection
                        simulatorSection
                        loginSection
                        legalSection
                    }
                    .padding(AppTheme.spacing)
                }
            }
            .navigationDestination(isPresented: $showLogin) {
                LoginView()
            }
            .navigationDestination(isPresented: $showSimulatorResult) {
                if let result = vm.simulatorResult {
                    SimulatorResultView(result: result)
                }
            }
        }
    }

    private var heroSection: some View {
        VStack(spacing: AppTheme.spacing) {
            Spacer().frame(height: 20)

            Image(systemName: "car.fill")
                .font(.system(size: 64))
                .foregroundStyle(AppTheme.primaryGradient)

            Text("Group 2k25")
                .font(.system(size: 36, weight: .bold))
                .foregroundStyle(.primary)

            Text("Crédito inteligente para motoristas de Uber")
                .font(.title3)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
    }

    private var featuresSection: some View {
        VStack(spacing: AppTheme.spacing) {
            featureRow(icon: "bolt.fill", title: "Rápido", description: "Aprovação em até 24 horas")
            featureRow(icon: "lock.shield.fill", title: "Seguro", description: "Seus dados protegidos")
            featureRow(icon: "percent", title: "Juros justos", description: "Taxas a partir de 3,5% ao mês")
        }
    }

    private func featureRow(icon: String, title: String, description: String) -> some View {
        GlassCard {
            HStack(spacing: AppTheme.spacing) {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundStyle(.appPrimary)
                    .frame(width: 40)
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.headline)
                        .foregroundStyle(.primary)
                    Text(description)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                Spacer()
            }
        }
    }

    private var simulatorSection: some View {
        LoanSimulatorCard(
            weeklyEarnings: $vm.weeklyEarnings,
            isLoading: vm.isLoading,
            isValid: vm.isValid
        ) {
            Task {
                await vm.simulate()
                if vm.simulatorResult != nil {
                    showSimulatorResult = true
                }
            }
        }
    }

    private var loginSection: some View {
        VStack(spacing: AppTheme.spacing) {
            PrimaryButton(title: "Entrar com meu celular") {
                showLogin = true
            }

            Text("Já tem cadastro? Faça login para acessar sua conta.")
                .font(.caption)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
    }

    private var legalSection: some View {
        HStack(spacing: AppTheme.spacing) {
            NavigationLink("Termos de uso", destination: TermsView())
                .font(.caption)
                .foregroundStyle(.appAccent)
            NavigationLink("Privacidade", destination: PrivacyPolicyView())
                .font(.caption)
                .foregroundStyle(.appAccent)
        }
        .padding(.bottom, AppTheme.largeSpacing)
    }
}
