import SwiftUI

struct ContractListView: View {
    @State private var vm = ContractListViewModel()

    var body: some View {
        ZStack {
            GradientBackground()

            if vm.isLoading && vm.contracts.isEmpty {
                LoadingView()
            } else if let error = vm.errorMessage, vm.contracts.isEmpty {
                ErrorView(message: error) {
                    Task { await vm.loadContracts() }
                }
            } else if vm.contracts.isEmpty {
                EmptyStateView(
                    icon: "doc.text",
                    title: "Nenhum contrato",
                    message: "Você ainda não possui contratos ativos."
                )
            } else {
                contractList
            }
        }
        .navigationTitle("Contratos")
        .navigationBarTitleDisplayMode(.large)
        .task { await vm.loadContracts() }
        .refreshable { await vm.loadContracts() }
    }

    private var contractList: some View {
        ScrollView {
            LazyVStack(spacing: AppTheme.spacing) {
                ForEach(vm.contracts) { contract in
                    NavigationLink(value: CustomerDestination.contractDetail(contract.id)) {
                        contractCard(contract)
                    }
                }
            }
            .padding(AppTheme.spacing)
        }
    }

    private func contractCard(_ contract: Contract) -> some View {
        GlassCard {
            VStack(spacing: AppTheme.spacing) {
                HStack {
                    CurrencyText(amount: contract.loanAmount, font: .title3.bold())
                    Spacer()
                    StatusBadge(
                        text: contract.status.displayName,
                        color: contractStatusColor(contract.status)
                    )
                }

                HStack {
                    infoItem(label: "Parcelas", value: "\(contract.numberOfInstallments)x")
                    Spacer()
                    infoItem(label: "Valor parcela", value: contract.installmentAmount.asCurrency)
                    Spacer()
                    infoItem(label: "Juros", value: "\(contract.interestRate)% a.m.")
                }

                if contract.createdAt != nil {
                    HStack {
                        Text("Criado em: \(contract.createdAtFormatted)")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        Spacer()
                        Image(systemName: "chevron.right")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
            }
        }
    }

    private func infoItem(label: String, value: String) -> some View {
        VStack(spacing: 2) {
            Text(label)
                .font(.caption2)
                .foregroundStyle(.secondary)
            Text(value)
                .font(.caption.bold())
                .foregroundStyle(.primary)
        }
    }

    private func contractStatusColor(_ status: ContractStatus) -> Color {
        switch status {
        case .aberto: return .appSuccess
        case .quitado: return .appPrimary
        case .atrasado: return .appDanger
        case .cancelado: return .secondary
        case .renegociado: return .appWarning
        }
    }
}
