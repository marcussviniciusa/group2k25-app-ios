import SwiftUI

struct PhoneTextField: View {
    @Binding var phone: String
    var placeholder: String = "(11) 99999-9999"

    var body: some View {
        HStack(spacing: AppTheme.smallSpacing) {
            Text("🇧🇷 +55")
                .font(.body)
                .foregroundStyle(.secondary)
            TextField(placeholder, text: $phone)
                .keyboardType(.numberPad)
                .textContentType(.telephoneNumber)
                .onChange(of: phone) { _, newValue in
                    let digits = newValue.digitsOnly
                    if digits.count <= 11 {
                        phone = digits.asPhoneMask
                    } else {
                        phone = String(digits.prefix(11)).asPhoneMask
                    }
                }
        }
        .padding()
        .background(Color.appSurface)
        .clipShape(RoundedRectangle(cornerRadius: AppTheme.buttonCornerRadius))
        .overlay(
            RoundedRectangle(cornerRadius: AppTheme.buttonCornerRadius)
                .stroke(Color.white.opacity(0.1), lineWidth: 1)
        )
    }
}
