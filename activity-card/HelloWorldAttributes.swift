import ActivityKit
import Foundation

struct HelloWorldAttributes: ActivityAttributes {
    public typealias LiveActivityStatus = ContentState
    
    public struct ContentState: Codable, Hashable {
        var message: String
        var leftText: String
        var rightText: String
        var minimalText: String
        var phonetic: String
        var partOfSpeech: String
        var example: String
    }
    
    var name: String
    
    public init(name: String) {
        self.name = name
    }
} 