import SwiftUI

struct LeadStatusView: View {
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
                statusRouter(lead)
            }
        }
        .navigationTitle("Solicitação")
        .navigationBarTitleDisplayMode(.large)
        .task { await vm.loadLead() }
        .refreshable { await vm.loadLead() }
    }

    @ViewBuilder
    private func statusRouter(_ lead: Lead) -> some View {
        ScrollView {
            VStack(spacing: AppTheme.spacing) {
                GlassCard {
                    HStack {
                        Text("Seu status")
                            .font(.headline)
                        Spacer()
                        LeadStatusBadge(status: lead.status)
                    }
                }

                switch lead.status {
                case .novo, .aguardandoGanhos:
                    stepCard(
                        step: 1,
                        title: "Enviar relatório de ganhos",
                        description: "Faça upload da captura de tela do seu relatório de ganhos semanais do Uber.",
                        actionDestination: .earningsUpload
                    )

                case .ganhosRecebidos, .ganhosAprovados:
                    pendingCard(title: "Analisando seus ganhos", description: "Estamos verificando seu relatório. Você será notificado em breve.")

                case .ganhosRejeitados:
                    rejectedCard(title: "Ganhos não aprovados", description: "Seu relatório de ganhos não atendeu aos critérios. Tente novamente com um novo relatório.")
                    stepCard(step: 1, title: "Reenviar relatório", description: "Envie um novo relatório de ganhos.", actionDestination: .earningsUpload)

                case .aguardandoAceite:
                    stepCard(step: 2, title: "Proposta disponível", description: "Veja os detalhes da proposta e aceite para continuar.", actionDestination: .proposal)

                case .propostaAceita, .aguardandoDocumentos:
                    stepCard(step: 3, title: "Enviar documentos", description: "Envie CNH, comprovante de endereço e captura do perfil Uber.", actionDestination: .documentUpload)

                case .documentosRecebidos, .documentosAprovados:
                    pendingCard(title: "Analisando documentos", description: "Estamos verificando seus documentos. Aguarde a aprovação final.")

                case .documentosRejeitados:
                    rejectedCard(title: "Documentos não aprovados", description: "Algum documento não foi aprovado. Reenvie documentos válidos.")
                    stepCard(step: 3, title: "Reenviar documentos", description: "Envie novos documentos.", actionDestination: .documentUpload)

                case .convertido:
                    GlassCard {
                        VStack(spacing: AppTheme.smallSpacing) {
                            Image(systemName: "party.popper.fill")
                                .font(.system(size: 48))
                                .foregroundStyle(.appSuccess)
                            Text("Empréstimo aprovado!")
                                .font(.title3.bold())
                                .foregroundStyle(.appSuccess)
                            Text("Seu empréstimo foi liberado. Acesse a aba de contratos para ver os detalhes.")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                                .multilineTextAlignment(.center)
                        }
                    }

                case .rejeitado:
                    rejectedCard(title: "Solicitação rejeitada", description: "Infelizmente sua solicitação não foi aprovada. Entre em contato para mais informações.")
                }
            }
            .padding(AppTheme.spacing)
        }
    }

    private func stepCard(step: Int, title: String, description: String, actionDestination: LeadDestination) -> some View {
        NavigationLink(value: actionDestination) {
            GlassCard {
                HStack(spacing: AppTheme.spacing) {
                    Text("\(step)")
                        .font(.title.bold())
                        .foregroundStyle(.appPrimary)
                        .frame(width: 40, height: 40)
                        .background(Color.appPrimary.opacity(0.15))
                        .clipShape(Circle())
                    VStack(alignment: .leading, spacing: 2) {
                        Text(title)
                            .font(.headline)
                            .foregroundStyle(.primary)
                        Text(description)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.leading)
                    }
                    Spacer()
                    Image(systemName: "chevron.right")
                        .foregroundStyle(.secondary)
                }
            }
        }
    }

    private func pendingCard(title: String, description: String) -> some View {
        GlassCard {
            VStack(spacing: AppTheme.smallSpacing) {
                ProgressView()
                    .tint(.appWarning)
                Text(title)
                    .font(.headline)
                    .foregroundStyle(.primary)
                Text(description)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }
        }
    }

    private func rejectedCard(title: String, description: String) -> some View {
        GlassCard {
            VStack(spacing: AppTheme.smallSpacing) {
                Image(systemName: "exclamationmark.triangle.fill")
                    .font(.title2)
                    .foregroundStyle(.appDanger)
                Text(title)
                    .font(.headline)
                    .foregroundStyle(.appDanger)
                Text(description)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }
        }
    }
}
