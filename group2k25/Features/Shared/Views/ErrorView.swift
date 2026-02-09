import SwiftUI

struct ErrorView: View {
    let message: String
    var retryAction: (() -> Void)?

    var body: some View {
        VStack(spacing: AppTheme.spacing) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 48))
                .foregroundStyle(.appDanger)
            Text("Ops! Algo deu errado")
                .font(.title3.bold())
                .foregroundStyle(.primary)
            Text(message)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
            if let retryAction {
                PrimaryButton(title: "Tentar novamente", action: retryAction)
                    .padding(.top, AppTheme.smallSpacing)
            }
        }
        .padding(AppTheme.largeSpacing)
    }
}
