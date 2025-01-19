//
//  ContentView.swift
//  activity-card
//
//  Created by 活点地图 on 2024/12/25.
//

import SwiftUI
import ActivityKit
import WidgetKit

@available(iOS 16.1, *)
@MainActor
struct ContentView: View {
    @State private var activity: Activity<HelloWorldAttributes>? = nil
    @State private var vocabularyItems: [VocabularyItem] = []
    @State private var isLoading = false
    @State private var errorMessage: String?
    @State private var showingDetail = false
    @State private var hasData = false
    @State private var currentIndex = 0
    private let feiShuService = FeiShuService()
    
    @State private var isTimerRunning = false
    private let timer = Timer.publish(every: 3, on: .main, in: .common).autoconnect()
    
    var body: some View {
        VStack(spacing: 20) {
            if hasData {
                Button("查看数据详情") {
                    showingDetail = true
                }
                .buttonStyle(.borderedProminent)
                
                Button("启动灵动岛") {
                    if startLiveActivity() {
                        minimizeApp()
                    }
                }
                .buttonStyle(.borderedProminent)
                
                if activity != nil {
                    Button("停止灵动岛") {
                        stopLiveActivity()
                    }
                    .buttonStyle(.bordered)
                    .foregroundColor(.red)
                }
                
                Button("清空数据集") {
                    vocabularyItems = []
                    hasData = false
                    stopLiveActivity()
                }
                .buttonStyle(.bordered)
                .foregroundColor(.red)
            } else {
                Button("拉取托福数据集") {
                    Task { @MainActor in
                        isLoading = true
                        errorMessage = nil
                        do {
                            vocabularyItems = try await feiShuService.fetchVocabularyItems()
                            hasData = true
                            _ = startLiveActivity()
                        } catch {
                            errorMessage = error.localizedDescription
                        }
                        isLoading = false
                    }
                }
                .buttonStyle(.borderedProminent)
                .disabled(isLoading)
            }
            
            if isLoading {
                ProgressView()
            }
            
            if let error = errorMessage {
                Text(error)
                    .foregroundColor(.red)
                    .font(.caption)
            }
        }
        .padding()
        .sheet(isPresented: $showingDetail) {
            VocabularyDetailView(vocabularyItems: vocabularyItems)
        }
        .onChange(of: isTimerRunning, initial: false) { _, newValue in
            if !newValue {
                stopLiveActivity()
            }
        }
        .onReceive(timer) { _ in
            guard isTimerRunning,
                  let currentActivity = activity,
                  !vocabularyItems.isEmpty else { return }
            
            currentIndex = (currentIndex + 1) % vocabularyItems.count
            let currentWord = vocabularyItems[currentIndex]
            
            Task { @MainActor in
                let state = HelloWorldAttributes.ContentState(
                    message: currentWord.word,
                    leftText: currentWord.word,
                    rightText: currentWord.definition,
                    minimalText: "📚"
                )
                let content = ActivityContent(state: state, staleDate: nil)
                await currentActivity.update(content)
            }
        }
    }
    
    func startLiveActivity() -> Bool {
        guard !vocabularyItems.isEmpty else { return false }
        
        currentIndex = 0
        let currentWord = vocabularyItems[currentIndex]
        
        let attributes = HelloWorldAttributes(name: "Dynamic Island")
        let state = HelloWorldAttributes.ContentState(
            message: currentWord.word,
            leftText: currentWord.word,
            rightText: currentWord.definition,
            minimalText: "📚"
        )
        let content = ActivityContent(state: state, staleDate: nil)
        
        do {
            activity = try Activity.request(attributes: attributes, content: content)
            print("灵动岛启动成功，开始单词：\(currentWord.word)")
            
            isTimerRunning = true
            return true
        } catch {
            print("Error: \(error.localizedDescription)")
            return false
        }
    }
    
    func stopLiveActivity() {
        isTimerRunning = false
        
        if let currentActivity = activity {
            Task {
                let state = HelloWorldAttributes.ContentState(
                    message: "再见",
                    leftText: "再见",
                    rightText: "再见",
                    minimalText: "👋"
                )
                let content = ActivityContent(state: state, staleDate: nil)
                await currentActivity.end(content, dismissalPolicy: .immediate)
                activity = nil
            }
        }
    }
    
    private func minimizeApp() {
        UIControl().sendAction(#selector(URLSessionTask.suspend), to: UIApplication.shared, for: nil)
    }
}

#Preview {
    if #available(iOS 16.1, *) {
        ContentView()
    } else {
        Text("Live Activities are available in iOS 16.1 and later.")
    }
}

