import SwiftUI

struct ProposalView: View {
    @State private var vm = ProposalViewModel()
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack {
            GradientBackground()

            if vm.isLoading && vm.proposal == nil {
                LoadingView()
            } else if let error = vm.errorMessage, vm.proposal == nil {
                ErrorView(message: error) {
                    Task { await vm.loadProposal() }
                }
            } else if let proposal = vm.proposal {
                proposalContent(proposal)
            }
        }
        .navigationTitle("Proposta")
        .navigationBarTitleDisplayMode(.inline)
        .task { await vm.loadProposal() }
        .onChange(of: vm.accepted) { _, accepted in
            if accepted { dismiss() }
        }
    }

    private func proposalContent(_ proposal: Proposal) -> some View {
        ScrollView {
            VStack(spacing: AppTheme.largeSpacing) {
                Image(systemName: "doc.plaintext.fill")
                    .font(.system(size: 48))
                    .foregroundStyle(AppTheme.primaryGradient)

                Text("Proposta de Empréstimo")
                    .font(.title2.bold())

                GlassCard {
                    VStack(spacing: AppTheme.spacing) {
                        proposalRow(label: "Valor do empréstimo", value: proposal.loanAmount.asCurrency, highlight: true)
                        Divider().overlay(Color.white.opacity(0.1))
                        proposalRow(label: "Valor total", value: proposal.totalAmount.asCurrency)
                        Divider().overlay(Color.white.opacity(0.1))
                        proposalRow(label: "Parcelas", value: "\(proposal.numberOfInstallments)x de \(proposal.installmentAmount.asCurrency)")
                        Divider().overlay(Color.white.opacity(0.1))
                        proposalRow(label: "Taxa de juros", value: "\(proposal.interestRate)% a.m.")
                        if let expires = proposal.expiresAt {
                            Divider().overlay(Color.white.opacity(0.1))
                            proposalRow(label: "Válida até", value: expires.asBrazilianDate)
                        }
                    }
                }

                if let error = vm.errorMessage {
                    Text(error)
                        .font(.caption)
                        .foregroundStyle(.appDanger)
                }

                PrimaryButton(
                    title: "Aceitar proposta",
                    isLoading: vm.isAccepting
                ) {
                    Task { await vm.acceptProposal() }
                }

                Text("Ao aceitar, você concorda com os termos do empréstimo. Você poderá enviar seus documentos na próxima etapa.")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }
            .padding(AppTheme.spacing)
        }
    }

    private func proposalRow(label: String, value: String, highlight: Bool = false) -> some View {
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
}
