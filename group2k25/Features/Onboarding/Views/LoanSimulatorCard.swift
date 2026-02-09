import SwiftUI

struct LoanSimulatorCard: View {
    @Binding var weeklyEarnings: String
    var isLoading: Bool
    var isValid: Bool
    var onSimulate: () -> Void

    var body: some View {
        GlassCard {
            VStack(spacing: AppTheme.spacing) {
                HStack {
                    Image(systemName: "chart.bar.fill")
                        .foregroundStyle(.appPrimary)
                    Text("Simulador de Empréstimo")
                        .font(.headline)
                        .foregroundStyle(.primary)
                    Spacer()
                }

                VStack(alignment: .leading, spacing: AppTheme.smallSpacing) {
                    Text("Quanto você ganha por semana no Uber?")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)

                    HStack {
                        Text("R$")
                            .font(.title3.bold())
                            .foregroundStyle(.secondary)
                        TextField("0,00", text: $weeklyEarnings)
                            .keyboardType(.decimalPad)
                            .font(.title3.bold())
                    }
                    .padding()
                    .background(Color.appSurface)
                    .clipShape(RoundedRectangle(cornerRadius: AppTheme.buttonCornerRadius))
                    .overlay(
                        RoundedRectangle(cornerRadius: AppTheme.buttonCornerRadius)
                            .stroke(Color.white.opacity(0.1), lineWidth: 1)
                    )
                }

                PrimaryButton(
                    title: "Simular agora",
                    isLoading: isLoading,
                    isDisabled: !isValid
                ) {
                    onSimulate()
                }
            }
        }
    }
}
