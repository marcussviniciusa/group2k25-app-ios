import SwiftUI

struct CustomerHomeView: View {
    @State private var vm = CustomerHomeViewModel()
    @Environment(AuthManager.self) private var authManager

    var body: some View {
        ZStack {
            GradientBackground()

            if vm.isLoading && vm.contracts.isEmpty {
                LoadingView()
            } else if let error = vm.errorMessage, vm.contracts.isEmpty {
                ErrorView(message: error) {
                    Task { await vm.loadDashboard() }
                }
            } else {
                dashboardContent
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
        .task { await vm.loadDashboard() }
        .refreshable { await vm.loadDashboard() }
    }

    private var dashboardContent: some View {
        ScrollView {
            VStack(spacing: AppTheme.spacing) {
                welcomeCard
                summaryCards
                if let next = vm.nextInstallment {
                    nextInstallmentCard(next)
                }
                contractsPreview
            }
            .padding(AppTheme.spacing)
        }
    }

    private var welcomeCard: some View {
        GlassCard {
            VStack(alignment: .leading, spacing: AppTheme.smallSpacing) {
                Text("Olá, \(authManager.currentUser?.name ?? "Cliente")!")
                    .font(.title2.bold())
                    .foregroundStyle(.primary)
                Text("Gerencie seus contratos e parcelas.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }

    private var summaryCards: some View {
        HStack(spacing: AppTheme.spacing) {
            GlassCard {
                VStack(spacing: 4) {
                    Text("\(vm.contracts.count)")
                        .font(.title.bold())
                        .foregroundStyle(.appPrimary)
                    Text("Contratos")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity)
            }

            GlassCard {
                VStack(spacing: 4) {
                    Text("\(vm.overdueCount)")
                        .font(.title.bold())
                        .foregroundStyle(vm.overdueCount > 0 ? .appDanger : .appSuccess)
                    Text("Atrasadas")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity)
            }
        }
    }

    private func nextInstallmentCard(_ installment: Installment) -> some View {
        VStack(alignment: .leading, spacing: AppTheme.smallSpacing) {
            Text("Próxima parcela")
                .font(.headline)
                .foregroundStyle(.primary)
            InstallmentRow(installment: installment)
        }
    }

    private var contractsPreview: some View {
        VStack(alignment: .leading, spacing: AppTheme.smallSpacing) {
            HStack {
                Text("Contratos")
                    .font(.headline)
                    .foregroundStyle(.primary)
                Spacer()
                NavigationLink(value: CustomerDestination.installments) {
                    Text("Ver todos")
                        .font(.caption.bold())
                        .foregroundStyle(.appAccent)
                }
            }

            ForEach(vm.contracts.prefix(3)) { contract in
                NavigationLink(value: CustomerDestination.contractDetail(contract.id)) {
                    contractRow(contract)
                }
            }
        }
    }

    private func contractRow(_ contract: Contract) -> some View {
        GlassCard {
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text(contract.loanAmount.asCurrency)
                        .font(.headline)
                        .foregroundStyle(.primary)
                    Text("\(contract.numberOfInstallments)x de \(contract.installmentAmount.asCurrency)")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                Spacer()
                StatusBadge(
                    text: contract.status.displayName,
                    color: contractStatusColor(contract.status)
                )
            }
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
