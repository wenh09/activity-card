//
//  widget_wordLiveActivity.swift
//  widget_word
//
//  Created by 活点地图 on 2024/12/25.
//

import ActivityKit
import SwiftUI
import WidgetKit

@available(iOS 16.1, *)
struct widget_wordLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration<HelloWorldAttributes>(for: HelloWorldAttributes.self) { _ in
            EmptyView()
        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded View
                DynamicIslandExpandedRegion(.center) {
                    HStack(spacing: 12) {
                        Text(context.state.leftText)
                            .bold()
                            .font(.system(size: 18))
                        
                        Text(context.state.rightText)
                            .font(.system(size: 18))
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
                Text("📚")
            }
            .widgetURL(URL(string: "widget-word://refresh"))
            .keylineTint(.cyan)
        }
    }
}

@available(iOS 16.1, *)
struct widget_wordLiveActivity_Previews: PreviewProvider {
    static let attributes = HelloWorldAttributes(name: "TOEFL Words")
    static let contentState = HelloWorldAttributes.ContentState(
        message: "abandon",
        leftText: "abandon",
        rightText: "放弃",
        minimalText: "📚"
    )
    
    static var previews: some View {
        attributes
            .previewContext(contentState, viewKind: .dynamicIsland(.compact))
            .previewDisplayName("Island Compact")
        attributes
            .previewContext(contentState, viewKind: .dynamicIsland(.expanded))
            .previewDisplayName("Island Expanded")
        attributes
            .previewContext(contentState, viewKind: .dynamicIsland(.minimal))
            .previewDisplayName("Minimal")
    }
}
