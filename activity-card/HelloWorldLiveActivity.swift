import ActivityKit
import SwiftUI
import WidgetKit

@available(iOS 16.1, *)
struct HelloWorldLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration<HelloWorldAttributes>(for: HelloWorldAttributes.self) { _ in
            EmptyView()
        } dynamicIsland: { context in
            let _ = print("Dynamic Island update triggered: \(context.state.leftText) - \(context.state.rightText)")
            
            return DynamicIsland {
                DynamicIslandExpandedRegion(.center) {
                    HStack(spacing: 12) {
                        VStack(alignment: .leading) {
                            Text(context.state.leftText)
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(.white)
                            Text("Word")
                                .font(.system(size: 12))
                                .foregroundColor(.gray)
                        }
                        
                        VStack(alignment: .trailing) {
                            Text(context.state.rightText)
                                .font(.system(size: 16))
                                .foregroundColor(.white)
                            Text("Definition")
                                .font(.system(size: 12))
                                .foregroundColor(.gray)
                        }
                    }
                    .padding(.horizontal)
                }
            } compactLeading: {
                Text(context.state.leftText)
                    .font(.system(size: 14))
                    .bold()
            } compactTrailing: {
                Text(context.state.rightText)
                    .font(.system(size: 14))
            } minimal: {
                Text(context.state.minimalText)
            }
        }
    }
}

#if canImport(SwiftUI) && DEBUG
@available(iOS 16.1, *)
struct HelloWorldLiveActivity_Previews: PreviewProvider {
    static let attributes = HelloWorldAttributes(name: "Me")
    static let contentState = HelloWorldAttributes.ContentState(
        message: "Hello",
        leftText: "Hello",
        rightText: "你好",
        minimalText: "📚"
    )

    static var previews: some View {
        EmptyView()
    }
}
#endif
