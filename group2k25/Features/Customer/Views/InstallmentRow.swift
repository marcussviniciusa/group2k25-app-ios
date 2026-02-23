import SwiftUI

struct InstallmentRow: View {
    let installment: Installment

    private var statusColor: Color {
        switch installment.status {
        case .pendente: return .appWarning
        case .pago: return .appSuccess
        case .atrasado: return .appDanger
        case .parcial: return .appWarning
        case .cancelado: return .secondary
        }
    }

    var body: some View {
        GlassCard {
            VStack(spacing: AppTheme.smallSpacing) {
                HStack {
                    Text("Parcela \(installment.number)")
                        .font(.headline)
                        .foregroundStyle(.primary)
                    Spacer()
                    StatusBadge(text: installment.status.displayName, color: statusColor)
                }

                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Valor")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        CurrencyText(amount: installment.amount, font: .subheadline.bold())
                    }
                    Spacer()
                    VStack(alignment: .trailing, spacing: 2) {
                        Text("Vencimento")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        Text(installment.dueDateFormatted)
                            .font(.subheadline.bold())
                            .foregroundStyle(.primary)
                    }
                }

                if installment.status == .pago, installment.paidAt != nil {
                    Text("Pago em \(installment.paidAtFormatted)")
                        .font(.caption)
                        .foregroundStyle(.appSuccess)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                }
            }
        }
    }
}
