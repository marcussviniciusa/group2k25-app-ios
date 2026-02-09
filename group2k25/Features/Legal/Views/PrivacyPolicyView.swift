import SwiftUI

struct PrivacyPolicyView: View {
    var body: some View {
        ZStack {
            GradientBackground()

            ScrollView {
                VStack(alignment: .leading, spacing: AppTheme.spacing) {
                    Text("Política de Privacidade")
                        .font(.largeTitle.bold())
                        .foregroundStyle(.primary)

                    Text("Última atualização: 01/01/2025")
                        .font(.caption)
                        .foregroundStyle(.secondary)

                    Group {
                        sectionTitle("1. Dados Coletados")
                        sectionBody("Coletamos dados pessoais como nome, telefone, CPF, endereço e informações financeiras necessárias para a análise de crédito e prestação dos serviços.")

                        sectionTitle("2. Uso dos Dados")
                        sectionBody("Seus dados são utilizados para análise de crédito, processamento de empréstimos, comunicações sobre sua conta e cumprimento de obrigações legais.")

                        sectionTitle("3. Compartilhamento")
                        sectionBody("Podemos compartilhar seus dados com parceiros financeiros, bureaus de crédito e autoridades regulatórias, conforme permitido pela LGPD.")

                        sectionTitle("4. Segurança")
                        sectionBody("Utilizamos medidas técnicas e organizacionais para proteger seus dados, incluindo criptografia e controle de acesso.")

                        sectionTitle("5. Seus Direitos")
                        sectionBody("Você tem direito a acessar, corrigir, excluir e portar seus dados pessoais. Para exercer seus direitos, entre em contato conosco.")

                        sectionTitle("6. Retenção")
                        sectionBody("Seus dados são mantidos pelo período necessário para a prestação dos serviços e cumprimento de obrigações legais.")

                        sectionTitle("7. Contato")
                        sectionBody("Para dúvidas sobre esta política, entre em contato pelo e-mail: privacidade@group2k25.com.br")
                    }
                }
                .padding(AppTheme.spacing)
            }
        }
        .navigationTitle("Privacidade")
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
