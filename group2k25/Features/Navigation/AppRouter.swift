import SwiftUI

nonisolated enum LeadDestination: Hashable {
    case earningsUpload
    case proposal
    case documentUpload
    case simulator
    case simulatorResult(SimulatorResult)
    case terms
    case privacy
}

nonisolated enum CustomerDestination: Hashable {
    case contractDetail(String)
    case installments
    case pixPayment(String)
    case terms
    case privacy
}

extension SimulatorResult: @retroactive Hashable {
    nonisolated public static func == (lhs: SimulatorResult, rhs: SimulatorResult) -> Bool {
        lhs.qualified == rhs.qualified && lhs.weeklyEarnings == rhs.weeklyEarnings
    }

    nonisolated public func hash(into hasher: inout Hasher) {
        hasher.combine(qualified)
        hasher.combine(weeklyEarnings)
    }
}
