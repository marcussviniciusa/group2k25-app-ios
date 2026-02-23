import SwiftUI

nonisolated enum CustomerDestination: Hashable {
    case contractDetail(String)
    case installments
    case terms
    case privacy
}
