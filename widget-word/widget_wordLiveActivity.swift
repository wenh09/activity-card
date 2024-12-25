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
        ActivityConfiguration<HelloWorldAttributes>(for: HelloWorldAttributes.self) { context in
            // Live Activity View (Dynamic Island)
            HStack {
                Text(context.state.message)
                    .foregroundColor(.white)
            }
            .padding()
            .activityBackgroundTint(.blue)
        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded View
                DynamicIslandExpandedRegion(.center) {
                    Text(context.state.message)
                        .foregroundColor(.white)
                }
            } compactLeading: {
                Text("Hello")
                    .foregroundColor(.white)
            } compactTrailing: {
                Text("World")
                    .foregroundColor(.white)
            } minimal: {
                Text("Hi")
                    .foregroundColor(.white)
            }
        }
    }
}

@available(iOS 16.1, *)
struct widget_wordLiveActivity_Previews: PreviewProvider {
    static let attributes = HelloWorldAttributes(name: "World")
    static let contentState = HelloWorldAttributes.ContentState(message: "Hello World")
    
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
        attributes
            .previewContext(contentState, viewKind: .content)
            .previewDisplayName("Notification")
    }
}
