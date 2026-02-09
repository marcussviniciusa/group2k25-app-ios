import Foundation

nonisolated enum UserType: String, Codable, Sendable {
    case lead
    case customer
}

nonisolated struct User: Codable, Sendable, Identifiable {
    let phone: String
    let type: UserType
    let name: String?
    let leadId: String?
    let customerId: String?
    let status: String?

    var id: String {
        customerId ?? leadId ?? phone
    }

    enum CodingKeys: String, CodingKey {
        case phone, type, name, leadId, customerId, status
    }
}

nonisolated struct MeResponse: Codable, Sendable {
    let user: User
}
