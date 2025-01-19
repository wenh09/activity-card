import ActivityKit
import SwiftUI
import WidgetKit

@available(iOS 16.1, *)
struct HelloWorldLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration<HelloWorldAttributes>(for: HelloWorldAttributes.self) { _ in
            EmptyView()
        } dynamicIsland: { context in
            DynamicIsland {
                DynamicIslandExpandedRegion(.center) {
                    VStack(alignment: .leading, spacing: 8) {
                        // 第一行：单词、音标、词性+释义
                        HStack(spacing: 12) {
                            Text(context.state.leftText)
                                .font(.system(size: 15, weight: .bold))
                            
                            Text(context.state.phonetic)
                                .font(.system(size: 15))
                            
                            Text("\(context.state.partOfSpeech) \(context.state.rightText)")
                                .font(.system(size: 15))
                        }
                        .foregroundColor(.white)
                        
                        // 第二行：例句
                        Text(context.state.example)
                            .font(.system(size: 12))
                            .foregroundColor(.gray)
                            .lineLimit(2)
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
        minimalText: "📚",
        phonetic: "[həˈləʊ]",
        partOfSpeech: "int.",
        example: "Hello, how are you today?"
    )

    static var previews: some View {
        EmptyView()
    }
}
#endif
