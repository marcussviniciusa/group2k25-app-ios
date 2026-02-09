import SwiftUI

struct CurrencyText: View {
    let amount: Decimal
    var font: Font = .title2.bold()
    var color: Color = .primary

    var body: some View {
        Text(amount.asCurrency)
            .font(font)
            .foregroundStyle(color)
    }
}
