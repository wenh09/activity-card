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
        
        public init(
            message: String,
            leftText: String,
            rightText: String,
            minimalText: String,
            phonetic: String,
            partOfSpeech: String,
            example: String
        ) {
            self.message = message
            self.leftText = leftText
            self.rightText = rightText
            self.minimalText = minimalText
            self.phonetic = phonetic
            self.partOfSpeech = partOfSpeech
            self.example = example
        }
    }
    
    var name: String
    
    public init(name: String) {
        self.name = name
    }
}
