import SwiftUI

struct PrimaryButton: View {
    let title: String
    var isLoading: Bool = false
    var isDisabled: Bool = false
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: AppTheme.smallSpacing) {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(.circular)
                        .tint(.white)
                        .scaleEffect(0.8)
                }
                Text(title)
                    .fontWeight(.semibold)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .background(AppTheme.primaryGradient)
            .foregroundStyle(.white)
            .clipShape(RoundedRectangle(cornerRadius: AppTheme.buttonCornerRadius))
        }
        .disabled(isLoading || isDisabled)
        .opacity(isDisabled ? 0.5 : 1)
    }
}
