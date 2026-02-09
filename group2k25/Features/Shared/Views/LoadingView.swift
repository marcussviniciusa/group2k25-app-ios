import SwiftUI

struct LoadingView: View {
    var message: String = "Carregando..."

    var body: some View {
        ZStack {
            GradientBackground()
            VStack(spacing: AppTheme.spacing) {
                ProgressView()
                    .progressViewStyle(.circular)
                    .tint(.appPrimary)
                    .scaleEffect(1.5)
                Text(message)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
    }
}
