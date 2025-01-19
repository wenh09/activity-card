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
                    .font(.system(size: 12))
                    .bold()
            } compactTrailing: {
                Text(context.state.rightText)
                    .font(.system(size: 12))
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
        minimalText: "📚",
        phonetic: "[ə'bændən]",
        partOfSpeech: "v.",
        example: "The hikers had to abandon their original plan due to the severe weather conditions."
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
