import SwiftUI

struct LeadTabView: View {
    @Environment(AuthManager.self) private var authManager

    var body: some View {
        TabView {
            Tab("Início", systemImage: "house.fill") {
                NavigationStack {
                    LeadHomeView()
                        .navigationDestination(for: LeadDestination.self) { destination in
                            switch destination {
                            case .earningsUpload:
                                EarningsUploadView()
                            case .proposal:
                                ProposalView()
                            case .documentUpload:
                                DocumentUploadView()
                            case .simulator:
                                SimulatorView()
                            case .simulatorResult(let result):
                                SimulatorResultView(result: result)
                            case .terms:
                                TermsView()
                            case .privacy:
                                PrivacyPolicyView()
                            }
                        }
                }
            }

            Tab("Solicitação", systemImage: "doc.text.fill") {
                NavigationStack {
                    LeadStatusView()
                        .navigationDestination(for: LeadDestination.self) { destination in
                            switch destination {
                            case .earningsUpload:
                                EarningsUploadView()
                            case .proposal:
                                ProposalView()
                            case .documentUpload:
                                DocumentUploadView()
                            case .simulator:
                                SimulatorView()
                            case .simulatorResult(let result):
                                SimulatorResultView(result: result)
                            case .terms:
                                TermsView()
                            case .privacy:
                                PrivacyPolicyView()
                            }
                        }
                }
            }

            Tab("Simular", systemImage: "chart.line.uptrend.xyaxis") {
                NavigationStack {
                    SimulatorView()
                        .navigationDestination(for: LeadDestination.self) { destination in
                            switch destination {
                            case .simulatorResult(let result):
                                SimulatorResultView(result: result)
                            default:
                                EmptyView()
                            }
                        }
                }
            }
        }
        .tint(.appPrimary)
        .onChange(of: authManager.userType) { _, newType in
            // If lead becomes customer, AuthManager state change handles navigation
        }
    }
}
