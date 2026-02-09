import Foundation

nonisolated enum APIConfiguration {
    #if DEBUG
    static var baseURL = URL(string: "http://localhost:3001/api/v1/portal")!
    #else
    static var baseURL = URL(string: "https://api.group2k25.com.br/api/v1/portal")!
    #endif
}
