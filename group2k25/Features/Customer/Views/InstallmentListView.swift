import SwiftUI

struct InstallmentListView: View {
    @State private var vm = InstallmentListViewModel()

    var body: some View {
        ZStack {
            GradientBackground()

            VStack(spacing: 0) {
                filterPicker
                    .padding(.horizontal, AppTheme.spacing)
                    .padding(.top, AppTheme.smallSpacing)

                if vm.isLoading && vm.installments.isEmpty {
                    Spacer()
                    ProgressView()
                        .tint(.appPrimary)
                    Spacer()
                } else if let error = vm.errorMessage, vm.installments.isEmpty {
                    ErrorView(message: error) {
                        Task { await vm.loadInstallments() }
                    }
                } else if vm.filteredInstallments.isEmpty {
                    Spacer()
                    EmptyStateView(
                        icon: "calendar",
                        title: "Nenhuma parcela",
                        message: "Nenhuma parcela encontrada para o filtro selecionado."
                    )
                    Spacer()
                } else {
                    installmentList
                }
            }
        }
        .navigationTitle("Parcelas")
        .navigationBarTitleDisplayMode(.large)
        .task { await vm.loadInstallments() }
        .refreshable { await vm.loadInstallments() }
        .onChange(of: vm.selectedFilter) { _, _ in
            Task { await vm.loadInstallments() }
        }
    }

    private var filterPicker: some View {
        Picker("Filtro", selection: $vm.selectedFilter) {
            ForEach(InstallmentListViewModel.InstallmentFilter.allCases, id: \.self) { filter in
                Text(filter.rawValue).tag(filter)
            }
        }
        .pickerStyle(.segmented)
    }

    private var installmentList: some View {
        ScrollView {
            LazyVStack(spacing: AppTheme.spacing) {
                ForEach(vm.filteredInstallments) { installment in
                    InstallmentRow(installment: installment)
                }
            }
            .padding(AppTheme.spacing)
        }
    }
}
