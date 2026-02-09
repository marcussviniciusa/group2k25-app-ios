import SwiftUI

struct GlassCard<Content: View>: View {
    @ViewBuilder let content: () -> Content

    var body: some View {
        content()
            .padding(AppTheme.spacing)
            .glassStyle()
    }
}
