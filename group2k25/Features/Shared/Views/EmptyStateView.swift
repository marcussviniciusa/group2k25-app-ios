import SwiftUI

struct EmptyStateView: View {
    let icon: String
    let title: String
    let message: String

    var body: some View {
        VStack(spacing: AppTheme.spacing) {
            Image(systemName: icon)
                .font(.system(size: 48))
                .foregroundStyle(.secondary)
            Text(title)
                .font(.title3.bold())
                .foregroundStyle(.primary)
            Text(message)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding(AppTheme.largeSpacing)
    }
}
