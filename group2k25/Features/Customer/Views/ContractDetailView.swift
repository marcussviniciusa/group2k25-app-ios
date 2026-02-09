import SwiftUI

struct ContractDetailView: View {
    @State private var vm: ContractDetailViewModel

    init(contractId: String) {
        _vm = State(initialValue: ContractDetailViewModel(contractId: contractId))
    }

    var body: some View {
        ZStack {
            GradientBackground()

            if vm.isLoading && vm.contract == nil {
                LoadingView()
            } else if let error = vm.errorMessage, vm.contract == nil {
                ErrorView(message: error) {
                    Task { await vm.loadContract() }
                }
            } else if let contract = vm.contract {
                contractContent(contract)
            }
        }
        .navigationTitle("Contrato")
        .navigationBarTitleDisplayMode(.inline)
        .task { await vm.loadContract() }
    }

    private func contractContent(_ contract: Contract) -> some View {
        ScrollView {
            VStack(spacing: AppTheme.spacing) {
                summaryCard(contract)
                progressCard
                installmentsSection
            }
            .padding(AppTheme.spacing)
        }
    }

    private func summaryCard(_ contract: Contract) -> some View {
        GlassCard {
            VStack(spacing: AppTheme.spacing) {
                HStack {
                    Text("Resumo")
                        .font(.headline)
                    Spacer()
                    StatusBadge(
                        text: contract.status.displayName,
                        color: contract.status == .aberto ? .appSuccess : .secondary
                    )
                }
                infoRow(label: "Valor emprestado", value: contract.loanAmount.asCurrency)
                Divider().overlay(Color.white.opacity(0.1))
                infoRow(label: "Valor total", value: contract.totalAmount.asCurrency)
                Divider().overlay(Color.white.opacity(0.1))
                infoRow(label: "Parcelas", value: "\(contract.numberOfInstallments)x de \(contract.installmentAmount.asCurrency)")
                Divider().overlay(Color.white.opacity(0.1))
                infoRow(label: "Taxa de juros", value: "\(contract.interestRate)% a.m.")
            }
        }
    }

    private var progressCard: some View {
        GlassCard {
            VStack(spacing: AppTheme.smallSpacing) {
                HStack {
                    Text("Progresso")
                        .font(.headline)
                    Spacer()
                    Text("\(vm.paidCount)/\(vm.installments.count)")
                        .font(.subheadline.bold())
                        .foregroundStyle(.appPrimary)
                }
                ProgressView(value: vm.progress)
                    .tint(.appPrimary)
                Text("\(Int(vm.progress * 100))% concluído")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
    }

    private var installmentsSection: some View {
        VStack(alignment: .leading, spacing: AppTheme.smallSpacing) {
            Text("Parcelas")
                .font(.headline)
                .foregroundStyle(.primary)

            ForEach(vm.installments) { installment in
                InstallmentRow(installment: installment)
            }
        }
    }

    private func infoRow(label: String, value: String) -> some View {
        HStack {
            Text(label)
                .font(.subheadline)
                .foregroundStyle(.secondary)
            Spacer()
            Text(value)
                .font(.subheadline.bold())
                .foregroundStyle(.primary)
        }
    }
}
