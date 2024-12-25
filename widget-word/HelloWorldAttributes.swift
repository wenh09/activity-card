import ActivityKit
import Foundation

struct HelloWorldAttributes: ActivityAttributes {
    public typealias LiveActivityStatus = ContentState
    
    public struct ContentState: Codable, Hashable {
        var message: String
        var leftText: String
        var rightText: String
        var minimalText: String
        
        public init(
            message: String = "Hello World",
            leftText: String = "恭喜发财",
            rightText: String = "红包拿来",
            minimalText: String = "💗"
        ) {
            self.message = message
            self.leftText = leftText
            self.rightText = rightText
            self.minimalText = minimalText
        }
    }
    
    var name: String
    
    public init(name: String) {
        self.name = name
    }
}
