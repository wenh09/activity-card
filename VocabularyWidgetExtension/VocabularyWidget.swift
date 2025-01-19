import WidgetKit
import SwiftUI
import ActivityKit

@main
struct VocabularyWidgets: WidgetBundle {
    var body: some Widget {
        if #available(iOS 16.1, *) {
            HelloWorldLiveActivity()
        }
    }
}

@available(iOS 16.1, *)
struct HelloWorldLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: HelloWorldAttributes.self) { context in
            HStack {
                Text(context.state.leftText)
                    .font(.system(size: 12))
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text(context.state.rightText)
                    .font(.system(size: 12))
                    .frame(maxWidth: .infinity, alignment: .trailing)
            }
            .padding(.horizontal, 9)
            .foregroundColor(.white)
        } dynamicIsland: { context in
            DynamicIsland {
                DynamicIslandExpandedRegion(.leading) {
                    Text(context.state.leftText)
                        .font(.system(size: 12))
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                
                DynamicIslandExpandedRegion(.trailing) {
                    Text(context.state.rightText)
                        .font(.system(size: 12))
                        .frame(maxWidth: .infinity, alignment: .trailing)
                }
                
                DynamicIslandExpandedRegion(.center) {
                    Text(context.state.message)
                        .font(.system(size: 12))
                }
            } compactLeading: {
                Text(context.state.leftText)
                    .font(.system(size: 12))
                    .frame(alignment: .leading)
                    .padding(.leading, 9)
            } compactTrailing: {
                Text(context.state.rightText)
                    .font(.system(size: 12))
                    .frame(alignment: .trailing)
                    .padding(.trailing, 9)
            } minimal: {
                Text(context.state.minimalText)
            }
            .keylineTint(.clear)
        }
    }
} 