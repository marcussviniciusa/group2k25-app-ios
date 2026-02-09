import SwiftUI

struct LoadingModifier: ViewModifier {
    let isLoading: Bool

    func body(content: Content) -> some View {
        content
            .disabled(isLoading)
            .overlay {
                if isLoading {
                    ZStack {
                        Color.black.opacity(0.3)
                            .ignoresSafeArea()
                        ProgressView()
                            .progressViewStyle(.circular)
                            .tint(.white)
                            .scaleEffect(1.2)
                            .padding(24)
                            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
                    }
                }
            }
    }
}

extension View {
    func withLoading(_ isLoading: Bool) -> some View {
        modifier(LoadingModifier(isLoading: isLoading))
    }
}
