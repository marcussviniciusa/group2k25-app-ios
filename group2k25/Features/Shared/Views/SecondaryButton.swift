import SwiftUI

struct SecondaryButton: View {
    let title: String
    var isLoading: Bool = false
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: AppTheme.smallSpacing) {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(.circular)
                        .tint(.appPrimary)
                        .scaleEffect(0.8)
                }
                Text(title)
                    .fontWeight(.semibold)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .foregroundStyle(.appPrimary)
            .overlay(
                RoundedRectangle(cornerRadius: AppTheme.buttonCornerRadius)
                    .stroke(Color.appPrimary, lineWidth: 1.5)
            )
        }
        .disabled(isLoading)
    }
}
