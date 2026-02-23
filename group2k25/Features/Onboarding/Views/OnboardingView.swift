import SwiftUI

struct OnboardingView: View {
    @State private var showLogin = false

    var body: some View {
        NavigationStack {
            ZStack {
                GradientBackground()

                ScrollView {
                    VStack(spacing: AppTheme.largeSpacing) {
                        heroSection
                        featuresSection
                        loginSection
                        legalSection
                    }
                    .padding(AppTheme.spacing)
                }
            }
            .navigationDestination(isPresented: $showLogin) {
                LoginView()
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

            Text("Acompanhe suas parcelas e receba lembretes")
                .font(.title3)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
    }

    private var featuresSection: some View {
        VStack(spacing: AppTheme.spacing) {
            featureRow(icon: "doc.text.fill", title: "Contratos", description: "Acompanhe seus contratos em tempo real")
            featureRow(icon: "calendar", title: "Parcelas", description: "Veja o status de todas as suas parcelas")
            featureRow(icon: "bell.fill", title: "Lembretes", description: "Receba notificações de vencimento")
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

    private var loginSection: some View {
        VStack(spacing: AppTheme.spacing) {
            PrimaryButton(title: "Entrar com meu celular") {
                showLogin = true
            }

            Text("Faça login para acessar seus contratos e parcelas.")
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
