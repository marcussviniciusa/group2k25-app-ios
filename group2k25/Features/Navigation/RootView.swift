import SwiftUI

struct RootView: View {
    @State private var authManager = AuthManager()

    var body: some View {
        Group {
            switch authManager.state {
            case .loading:
                LoadingView(message: "Verificando sessão...")
            case .unauthenticated:
                OnboardingView()
            case .authenticated(let user):
                switch user.type {
                case .lead:
                    LeadTabView()
                case .customer:
                    CustomerTabView()
                }
            }
        }
        .environment(authManager)
        .task {
            await authManager.checkSession()
        }
        .preferredColorScheme(.dark)
    }
}
