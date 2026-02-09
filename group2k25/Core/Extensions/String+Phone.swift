import Foundation

extension String {
    var asPhoneMask: String {
        let digits = self.filter(\.isNumber)
        guard !digits.isEmpty else { return "" }

        var result = ""
        let chars = Array(digits)

        for (index, char) in chars.enumerated() {
            switch index {
            case 0:
                result.append("(")
                result.append(char)
            case 1:
                result.append(char)
                result.append(") ")
            case 6:
                result.append(char)
                result.append("-")
            default:
                if index < 11 {
                    result.append(char)
                }
            }
        }
        return result
    }

    var digitsOnly: String {
        filter(\.isNumber)
    }

    var isValidBrazilianPhone: Bool {
        let digits = self.digitsOnly
        return digits.count == 11 && digits.hasPrefix("") && digits[digits.index(digits.startIndex, offsetBy: 2)] == "9"
    }
}
