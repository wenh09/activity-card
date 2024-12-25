//
//  widget_wordLiveActivity.swift
//  widget-word
//
//  Created by 活点地图 on 2024/12/25.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct widget_wordAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct widget_wordLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: widget_wordAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack {
                Text("Hello \(context.state.emoji)")
            }
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Text("Leading")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Trailing")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Bottom \(context.state.emoji)")
                    // more content
                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("T \(context.state.emoji)")
            } minimal: {
                Text(context.state.emoji)
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

extension widget_wordAttributes {
    fileprivate static var preview: widget_wordAttributes {
        widget_wordAttributes(name: "World")
    }
}

extension widget_wordAttributes.ContentState {
    fileprivate static var smiley: widget_wordAttributes.ContentState {
        widget_wordAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: widget_wordAttributes.ContentState {
         widget_wordAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: widget_wordAttributes.preview) {
   widget_wordLiveActivity()
} contentStates: {
    widget_wordAttributes.ContentState.smiley
    widget_wordAttributes.ContentState.starEyes
}
