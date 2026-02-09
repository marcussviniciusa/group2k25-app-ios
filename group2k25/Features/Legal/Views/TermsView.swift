import SwiftUI

struct TermsView: View {
    var body: some View {
        ZStack {
            GradientBackground()

            ScrollView {
                VStack(alignment: .leading, spacing: AppTheme.spacing) {
                    Text("Termos de Uso")
                        .font(.largeTitle.bold())
                        .foregroundStyle(.primary)

                    Text("Última atualização: 01/01/2025")
                        .font(.caption)
                        .foregroundStyle(.secondary)

                    Group {
                        sectionTitle("1. Aceitação dos Termos")
                        sectionBody("Ao utilizar o aplicativo Group 2k25, você concorda com estes termos de uso. Se não concordar, não utilize o aplicativo.")

                        sectionTitle("2. Serviços")
                        sectionBody("O Group 2k25 oferece serviços de crédito pessoal para motoristas de aplicativo. Os empréstimos estão sujeitos à análise de crédito e aprovação.")

                        sectionTitle("3. Cadastro")
                        sectionBody("Para utilizar nossos serviços, você deve fornecer informações verdadeiras e manter seus dados atualizados. O uso de informações falsas pode resultar no cancelamento da conta.")

                        sectionTitle("4. Responsabilidades")
                        sectionBody("O usuário é responsável por manter a confidencialidade de suas credenciais de acesso e por todas as atividades realizadas em sua conta.")

                        sectionTitle("5. Pagamentos")
                        sectionBody("Os pagamentos devem ser realizados nas datas de vencimento acordadas. O atraso no pagamento está sujeito a multa e juros conforme estabelecido no contrato.")

                        sectionTitle("6. Privacidade")
                        sectionBody("O tratamento de dados pessoais segue nossa Política de Privacidade, em conformidade com a Lei Geral de Proteção de Dados (LGPD).")

                        sectionTitle("7. Alterações")
                        sectionBody("Reservamo-nos o direito de alterar estes termos a qualquer momento. As alterações entram em vigor após publicação no aplicativo.")
                    }
                }
                .padding(AppTheme.spacing)
            }
        }
        .navigationTitle("Termos de Uso")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func sectionTitle(_ text: String) -> some View {
        Text(text)
            .font(.headline)
            .foregroundStyle(.primary)
            .padding(.top, AppTheme.smallSpacing)
    }

    private func sectionBody(_ text: String) -> some View {
        Text(text)
            .font(.subheadline)
            .foregroundStyle(.secondary)
    }
}
