struct AuthResponse: Codable {
    let code: Int
    let msg: String
    let tenantAccessToken: String
    let expire: Int
    
    enum CodingKeys: String, CodingKey {
        case code
        case msg
        case tenantAccessToken = "tenant_access_token"
        case expire
    }
}

struct TableResponse: Codable {
    let code: Int
    let data: TableData?
    let msg: String
}

struct TableData: Codable {
    let items: [TableItem]
    let pageToken: String?
    let total: Int
    
    enum CodingKeys: String, CodingKey {
        case items
        case pageToken = "page_token"
        case total
    }
}

struct TableItem: Codable {
    let fields: [String: AnyCodable]
    
    struct AnyCodable: Codable {
        let value: String?
        
        init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            if let stringValue = try? container.decode(String.self) {
                value = stringValue
            } else {
                value = nil
            }
        }
    }
} 