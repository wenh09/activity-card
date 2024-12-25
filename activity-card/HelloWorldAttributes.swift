import ActivityKit
import Foundation

struct HelloWorldAttributes: ActivityAttributes {
    public typealias LiveActivityStatus = ContentState
    
    public struct ContentState: Codable, Hashable {
        var message: String
    }
    
    var name: String
} 