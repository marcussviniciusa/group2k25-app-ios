import SwiftUI

struct GlassModifier: ViewModifier {
    var cornerRadius: CGFloat = AppTheme.cardCornerRadius

    func body(content: Content) -> some View {
        content
            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: cornerRadius))
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(Color.white.opacity(0.1), lineWidth: 1)
            )
    }
}

extension View {
    func glassStyle(cornerRadius: CGFloat = AppTheme.cardCornerRadius) -> some View {
        modifier(GlassModifier(cornerRadius: cornerRadius))
    }
}
