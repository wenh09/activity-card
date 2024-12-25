import ActivityKit
import Foundation

public struct HelloWorldAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        public var message: String
        
        public init(message: String) {
            self.message = message
        }
    }
    
    public var name: String
    
    public init(name: String) {
        self.name = name
    }
}
