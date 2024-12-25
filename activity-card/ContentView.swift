//
//  ContentView.swift
//  activity-card
//
//  Created by 活点地图 on 2024/12/25.
//

import SwiftUI
import ActivityKit

@available(iOS 16.1, *)
struct ContentView: View {
    @State private var activity: Activity<HelloWorldAttributes>? = nil
    
    var body: some View {
        VStack(spacing: 20) {
            Button("开始灵动岛") {
                startLiveActivity()
            }
            .buttonStyle(.borderedProminent)
            
            if activity != nil {
                Button("停止灵动岛") {
                    stopLiveActivity()
                }
                .buttonStyle(.bordered)
            }
        }
        .padding()
    }
    
    func startLiveActivity() {
        let attributes = HelloWorldAttributes(name: "Dynamic Island")
        let state = HelloWorldAttributes.ContentState(message: "wen hao")
        let content = ActivityContent(state: state, staleDate: nil)
        
        do {
            let activity = try Activity.request(
                attributes: attributes,
                content: content
            )
            self.activity = activity
        } catch {
            print("Error: \(error.localizedDescription)")
        }
    }
    
    func stopLiveActivity() {
        Task {
            let state = HelloWorldAttributes.ContentState(message: "再见")
            let content = ActivityContent(state: state, staleDate: nil)
            await activity?.end(content, dismissalPolicy: .immediate)
        }
    }
}

#Preview {
    if #available(iOS 16.1, *) {
        ContentView()
    } else {
        Text("Live Activities are available in iOS 16.1 and later.")
    }
}
