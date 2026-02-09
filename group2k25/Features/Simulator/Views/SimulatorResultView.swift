import SwiftUI

struct SimulatorResultView: View {
    let result: SimulatorResult
    @Environment(AuthManager.self) private var authManager
    @State private var showLogin = false

    var body: some View {
        ZStack {
            GradientBackground()

            ScrollView {
                VStack(spacing: AppTheme.largeSpacing) {
                    statusIcon
                    resultCard
                    if result.qualified {
                        qualifiedActions
                    } else {
                        notQualifiedMessage
                    }
                }
                .padding(AppTheme.spacing)
            }
        }
        .navigationTitle("Resultado")
        .navigationBarTitleDisplayMode(.inline)
        .navigationDestination(isPresented: $showLogin) {
            LoginView()
        }
    }

    private var statusIcon: some View {
        VStack(spacing: AppTheme.spacing) {
            Image(systemName: result.qualified ? "checkmark.seal.fill" : "xmark.seal.fill")
                .font(.system(size: 64))
                .foregroundStyle(result.qualified ? Color.appSuccess : Color.appDanger)

            Text(result.qualified ? "Você está qualificado!" : "Não qualificado")
                .font(.title2.bold())
                .foregroundStyle(.primary)
        }
    }

    private var resultCard: some View {
        GlassCard {
            VStack(spacing: AppTheme.spacing) {
                infoRow(label: "Ganhos semanais", value: result.weeklyEarnings.asCurrency)

                if let maxLoan = result.maxLoanAmount {
                    Divider().overlay(Color.white.opacity(0.1))
                    infoRow(label: "Valor máximo do empréstimo", value: maxLoan.asCurrency, highlight: true)
                }

                if let installment = result.estimatedInstallment {
                    Divider().overlay(Color.white.opacity(0.1))
                    infoRow(label: "Parcela estimada", value: installment.asCurrency)
                }

                if let count = result.numberOfInstallments {
                    Divider().overlay(Color.white.opacity(0.1))
                    infoRow(label: "Número de parcelas", value: "\(count)x")
                }

                if let rate = result.interestRate {
                    Divider().overlay(Color.white.opacity(0.1))
                    infoRow(label: "Taxa de juros", value: "\(rate)% a.m.")
                }

                if let message = result.message {
                    Divider().overlay(Color.white.opacity(0.1))
                    Text(message)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
        }
    }

    private func infoRow(label: String, value: String, highlight: Bool = false) -> some View {
        HStack {
            Text(label)
                .font(.subheadline)
                .foregroundStyle(.secondary)
            Spacer()
            Text(value)
                .font(highlight ? .title3.bold() : .subheadline.bold())
                .foregroundStyle(highlight ? Color.appSuccess : .primary)
        }
    }

    private var qualifiedActions: some View {
        VStack(spacing: AppTheme.spacing) {
            if !authManager.isAuthenticated {
                PrimaryButton(title: "Solicitar empréstimo") {
                    showLogin = true
                }
                Text("Faça login para iniciar sua solicitação.")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            } else {
                GlassCard {
                    VStack(spacing: AppTheme.smallSpacing) {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundStyle(.appSuccess)
                        Text("Sua solicitação está em andamento!")
                            .font(.subheadline)
                            .foregroundStyle(.primary)
                    }
                }
            }
        }
    }

    private var notQualifiedMessage: some View {
        GlassCard {
            VStack(spacing: AppTheme.smallSpacing) {
                Image(systemName: "info.circle.fill")
                    .font(.title2)
                    .foregroundStyle(.appWarning)
                Text("No momento, o valor informado não atende aos critérios mínimos. Continue usando o app e tente novamente quando seus ganhos aumentarem.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }
        }
    }
}
