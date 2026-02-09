import SwiftUI

struct SimulatorView: View {
    @State private var vm = SimulatorViewModel()

    var body: some View {
        ZStack {
            GradientBackground()

            ScrollView {
                VStack(spacing: AppTheme.largeSpacing) {
                    headerSection

                    LoanSimulatorCard(
                        weeklyEarnings: $vm.weeklyEarnings,
                        isLoading: vm.isLoading,
                        isValid: vm.isValid
                    ) {
                        Task { await vm.simulate() }
                    }

                    if let error = vm.errorMessage {
                        Text(error)
                            .font(.caption)
                            .foregroundStyle(.appDanger)
                            .multilineTextAlignment(.center)
                    }

                    infoSection
                }
                .padding(AppTheme.spacing)
            }
        }
        .navigationTitle("Simulador")
        .navigationBarTitleDisplayMode(.large)
        .navigationDestination(item: $vm.result) { result in
            SimulatorResultView(result: result)
        }
    }

    private var headerSection: some View {
        VStack(spacing: AppTheme.smallSpacing) {
            Image(systemName: "chart.line.uptrend.xyaxis")
                .font(.system(size: 48))
                .foregroundStyle(AppTheme.primaryGradient)
            Text("Simule seu empréstimo")
                .font(.title2.bold())
                .foregroundStyle(.primary)
            Text("Descubra quanto você pode pegar emprestado com base nos seus ganhos semanais.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
    }

    private var infoSection: some View {
        GlassCard {
            VStack(alignment: .leading, spacing: AppTheme.smallSpacing) {
                Label("Como funciona?", systemImage: "questionmark.circle.fill")
                    .font(.headline)
                    .foregroundStyle(.appAccent)

                Text("1. Informe seus ganhos semanais no Uber")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                Text("2. Veja o valor máximo do empréstimo")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                Text("3. Conheça as condições (parcelas, juros)")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                Text("4. Se qualificado, faça sua solicitação")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
    }
}

extension SimulatorResult: Identifiable {
    var id: Decimal { weeklyEarnings }
}
