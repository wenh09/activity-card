import Foundation

enum FeiShuError: LocalizedError {
    case invalidResponse
    case apiError(code: Int, message: String)
    case networkError
    
    var errorDescription: String? {
        switch self {
        case .invalidResponse:
            return "无效的响应"
        case .apiError(_, let message):
            return message
        case .networkError:
            return "网络连接错误"
        }
    }
} 