import SwiftUI

struct CustomerTabView: View {
    var body: some View {
        TabView {
            Tab("Início", systemImage: "house.fill") {
                NavigationStack {
                    CustomerHomeView()
                        .navigationDestination(for: CustomerDestination.self) { destination in
                            customerDestinationView(destination)
                        }
                }
            }

            Tab("Contratos", systemImage: "doc.text.fill") {
                NavigationStack {
                    ContractListView()
                        .navigationDestination(for: CustomerDestination.self) { destination in
                            customerDestinationView(destination)
                        }
                }
            }

            Tab("Parcelas", systemImage: "calendar") {
                NavigationStack {
                    InstallmentListView()
                        .navigationDestination(for: CustomerDestination.self) { destination in
                            customerDestinationView(destination)
                        }
                }
            }
        }
        .tint(.appPrimary)
    }

    @ViewBuilder
    private func customerDestinationView(_ destination: CustomerDestination) -> some View {
        switch destination {
        case .contractDetail(let id):
            ContractDetailView(contractId: id)
        case .installments:
            InstallmentListView()
        case .terms:
            TermsView()
        case .privacy:
            PrivacyPolicyView()
        }
    }
}
