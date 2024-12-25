import ActivityKit
import SwiftUI
import WidgetKit

struct HelloWorldLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration<HelloWorldAttributes>(for: HelloWorldAttributes.self) { context in
            // Live Activity View (Dynamic Island)
            HStack {
                Text(context.state.message)
                    .font(.system(size: 12))
                    .foregroundColor(.white)
            }
            .padding()
            .activityBackgroundTint(.blue)
        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded View
                DynamicIslandExpandedRegion(.leading) {
                    Text(context.state.message)
                        .font(.system(size: 12))
                        .foregroundColor(.white)
                }
            } compactLeading: {
                // Compact Leading View
                HStack {
                    Text("wen")  // 左侧固定显示 "wen"
                        .font(.system(size: 12))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                }
                .frame(maxWidth: .infinity)
                .background(Color.blue.opacity(0.8))
            } compactTrailing: {
                // Compact Trailing View
                HStack {
                    Text("hao")  // 右侧固定显示 "hao"
                        .font(.system(size: 12))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                }
                .frame(maxWidth: .infinity)
                .background(Color.blue.opacity(0.8))
            } minimal: {
                // Minimal View
                Text("Hi")
                    .font(.system(size: 12))
                    .foregroundColor(.white)
            }
        }
        .contentMarginsDisabled()
    }
}

struct HelloWorldLiveActivity_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            // 预览锁屏界面
            ActivityConfiguration<HelloWorldAttributes>.ContentView(
                attributes: HelloWorldAttributes(name: "Preview"),
                state: HelloWorldAttributes.ContentState(message: "Preview Message")
            )
            .previewContext(WidgetPreviewContext(family: .systemMedium))
        }
    }
}
