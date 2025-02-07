import Foundation

// MARK: - VlessConfig Structure
struct VlessConfig {
    let id: String
    let host: String
    let port: Int
    let security: String
    let type: String
    let flow: String?
    let sni: String?
    let fingerprint: String?
    let publicKey: String?

    // MARK: - Initializer
    init?(from urlString: String) {
        guard let url = URLComponents(string: urlString),
              let user = url.user,
              let host = url.host,
              let port = url.port,
              let queryItems = url.queryItems else {
            print("Error: parsing VLESS URL")
            return nil
        }

        self.id = user
        self.host = host
        self.port = port
        self.security = queryItems.first(where: { $0.name == "security" })?.value ?? "none"
        self.type = queryItems.first(where: { $0.name == "type" })?.value ?? "tcp"
        self.flow = queryItems.first(where: { $0.name == "flow" })?.value
        self.sni = queryItems.first(where: { $0.name == "sni" })?.value
        self.fingerprint = queryItems.first(where: { $0.name == "fp" })?.value
        self.publicKey = queryItems.first(where: { $0.name == "pbk" })?.value
    }
}
