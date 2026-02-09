import SwiftUI

struct LeadHomeView: View {
    @State private var vm = LeadHomeViewModel()
    @Environment(AuthManager.self) private var authManager

    var body: some View {
        ZStack {
            GradientBackground()

            if vm.isLoading && vm.lead == nil {
                LoadingView()
            } else if let error = vm.errorMessage, vm.lead == nil {
                ErrorView(message: error) {
                    Task { await vm.loadLead() }
                }
            } else if let lead = vm.lead {
                leadContent(lead)
            }
        }
        .navigationTitle("Início")
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    Task { await authManager.logout() }
                } label: {
                    Image(systemName: "rectangle.portrait.and.arrow.right")
                        .foregroundStyle(.secondary)
                }
            }
        }
        .task { await vm.loadLead() }
        .refreshable { await vm.loadLead() }
    }

    private func leadContent(_ lead: Lead) -> some View {
        ScrollView {
            VStack(spacing: AppTheme.spacing) {
                welcomeCard(lead)
                statusCard(lead)
                actionCard(lead)
            }
            .padding(AppTheme.spacing)
        }
    }

    private func welcomeCard(_ lead: Lead) -> some View {
        GlassCard {
            VStack(alignment: .leading, spacing: AppTheme.smallSpacing) {
                Text("Olá, \(lead.name ?? "Motorista")!")
                    .font(.title2.bold())
                    .foregroundStyle(.primary)
                Text("Acompanhe aqui o status da sua solicitação de empréstimo.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }

    private func statusCard(_ lead: Lead) -> some View {
        GlassCard {
            VStack(alignment: .leading, spacing: AppTheme.spacing) {
                HStack {
                    Text("Status da solicitação")
                        .font(.headline)
                        .foregroundStyle(.primary)
                    Spacer()
                    LeadStatusBadge(status: lead.status)
                }

                if let earnings = lead.weeklyEarnings {
                    HStack {
                        Text("Ganhos semanais")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        Spacer()
                        CurrencyText(amount: earnings, font: .subheadline.bold())
                    }
                }
            }
        }
    }

    private func actionCard(_ lead: Lead) -> some View {
        Group {
            switch lead.status {
            case .novo, .aguardandoGanhos:
                NavigationLink(value: LeadDestination.earningsUpload) {
                    actionCardContent(
                        icon: "doc.text.image",
                        title: "Enviar relatório de ganhos",
                        description: "Faça upload do seu relatório de ganhos do Uber para continuar."
                    )
                }
            case .aguardandoAceite:
                NavigationLink(value: LeadDestination.proposal) {
                    actionCardContent(
                        icon: "doc.plaintext",
                        title: "Ver proposta",
                        description: "Você tem uma proposta de empréstimo aguardando seu aceite."
                    )
                }
            case .aguardandoDocumentos:
                NavigationLink(value: LeadDestination.documentUpload) {
                    actionCardContent(
                        icon: "doc.badge.plus",
                        title: "Enviar documentos",
                        description: "Envie CNH, comprovante de endereço e perfil Uber."
                    )
                }
            case .ganhosRecebidos, .ganhosAprovados, .propostaAceita, .documentosRecebidos, .documentosAprovados:
                GlassCard {
                    VStack(spacing: AppTheme.smallSpacing) {
                        ProgressView()
                            .tint(.appPrimary)
                        Text("Estamos analisando seus dados")
                            .font(.headline)
                            .foregroundStyle(.primary)
                        Text("Aguarde, você será notificado sobre as próximas etapas.")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                    }
                }
            case .convertido:
                GlassCard {
                    VStack(spacing: AppTheme.smallSpacing) {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.title)
                            .foregroundStyle(.appSuccess)
                        Text("Parabéns! Seu empréstimo foi aprovado!")
                            .font(.headline)
                            .foregroundStyle(.primary)
                        Text("Atualize o app para acessar seus contratos.")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
            case .ganhosRejeitados, .documentosRejeitados, .rejeitado:
                GlassCard {
                    VStack(spacing: AppTheme.smallSpacing) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.title)
                            .foregroundStyle(.appDanger)
                        Text("Solicitação não aprovada")
                            .font(.headline)
                            .foregroundStyle(.primary)
                        Text("Entre em contato conosco para mais informações.")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
            }
        }
    }

    private func actionCardContent(icon: String, title: String, description: String) -> some View {
        GlassCard {
            HStack(spacing: AppTheme.spacing) {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundStyle(.appPrimary)
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.headline)
                        .foregroundStyle(.primary)
                    Text(description)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundStyle(.secondary)
            }
        }
    }
}
