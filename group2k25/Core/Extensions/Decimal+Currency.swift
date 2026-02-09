import Foundation

extension Decimal {
    var asCurrency: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "pt_BR")
        formatter.currencyCode = "BRL"
        return formatter.string(from: self as NSDecimalNumber) ?? "R$ 0,00"
    }
}
