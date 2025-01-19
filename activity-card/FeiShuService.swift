import Foundation

class FeiShuService {
    private var tenantAccessToken: String?
    private let baseURL = "https://open.feishu.cn/open-apis"
    
    private func getTenantAccessToken() async throws -> String {
        if let token = tenantAccessToken {
            return token
        }
        
        let url = URL(string: "\(baseURL)/auth/v3/tenant_access_token/internal")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        
        let body = [
            "app_id": FeiShuConfig.appId,
            "app_secret": FeiShuConfig.appSecret
        ]
        request.httpBody = try JSONSerialization.data(withJSONObject: body)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw FeiShuError.invalidResponse
        }
        
        let authResponse = try JSONDecoder().decode(AuthResponse.self, from: data)
        guard authResponse.code == 0 else {
            throw FeiShuError.apiError(code: authResponse.code, message: authResponse.msg)
        }
        
        tenantAccessToken = authResponse.tenantAccessToken
        return authResponse.tenantAccessToken
    }
    
    func fetchVocabularyItems() async throws -> [VocabularyItem] {
        let token = try await getTenantAccessToken()
        print("Token获取成功: \(token.prefix(10))...")
        
        var allItems: [VocabularyItem] = []
        var pageToken: String? = nil
        let targetCount = 1000
        
        repeat {
            // 构建URL，如果有pageToken就添加到请求中
            var urlComponents = URLComponents(string: "\(baseURL)/bitable/v1/apps/\(FeiShuConfig.baseId)/tables/\(FeiShuConfig.tableId)/records")!
            var queryItems = [URLQueryItem(name: "page_size", value: "500")]
            if let pageToken = pageToken {
                queryItems.append(URLQueryItem(name: "page_token", value: pageToken))
            }
            urlComponents.queryItems = queryItems
            
            let url = urlComponents.url!
            print("请求URL: \(url)")
            
            var request = URLRequest(url: url)
            request.timeoutInterval = 30
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            
            let (data, httpResponse) = try await URLSession.shared.data(for: request)
            print("HTTP状态码: \((httpResponse as? HTTPURLResponse)?.statusCode ?? -1)")
            
            guard let httpResponse = httpResponse as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                throw FeiShuError.invalidResponse
            }
            
            let tableResponse = try JSONDecoder().decode(TableResponse.self, from: data)
            print("API响应码: \(tableResponse.code)")
            
            guard tableResponse.code == 0, let tableData = tableResponse.data else {
                throw FeiShuError.apiError(code: tableResponse.code, message: tableResponse.msg)
            }
            
            let items = tableData.items.map { item in
                return VocabularyItem(
                    id: Int(item.fields["序号"]?.value ?? "0") ?? 0,
                    serialNumber: item.fields["序号"]?.value ?? "",
                    word: item.fields["单词"]?.value ?? "",
                    definition: item.fields["释义"]?.value ?? "",
                    partOfSpeech: item.fields["词性"]?.value ?? "",
                    phonetic: item.fields["音标"]?.value ?? "",
                    example: item.fields["例句"]?.value ?? ""
                )
            }
            
            allItems.append(contentsOf: items)
            print("当前获取记录数: \(allItems.count)")
            
            // 更新pageToken用于下一次请求
            pageToken = tableData.pageToken
            
            // 如果已经获取足够的记录或没有更多数据，就退出循环
            if allItems.count >= targetCount || pageToken == nil {
                break
            }
            
        } while true
        
        // 如果获取的记录超过1000条，只返回前1000条
        let finalItems = Array(allItems.prefix(targetCount))
        print("最终处理完成，返回\(finalItems.count)条记录")
        return finalItems
    }
} 