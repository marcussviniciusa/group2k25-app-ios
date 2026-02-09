import SwiftUI

struct GradientBackground: View {
    var body: some View {
        AppTheme.backgroundGradient
            .ignoresSafeArea()
    }
}

extension View {
    func gradientBackground() -> some View {
        self.background { GradientBackground() }
    }
}
