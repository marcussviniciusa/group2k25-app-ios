import Foundation

nonisolated struct DocumentUploadRequest: Codable, Sendable {
    let cnh: String?
    let addressProof: String?
    let uberProfile: String?
}

nonisolated struct DocumentUploadResponse: Codable, Sendable {
    let message: String
    let documentsReceived: [String]?
}
