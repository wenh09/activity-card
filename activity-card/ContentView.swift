//
//  ContentView.swift
//  activity-card
//
//  Created by 活点地图 on 2024/12/25.
//

import SwiftUI
import ActivityKit
import WidgetKit
import Combine

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
    @State private var intervalSeconds: Double = 5.0  // 默认5秒
    private let feiShuService = FeiShuService()
    
    @State private var isTimerRunning = false
    @State private var timer: AnyCancellable?
    
    private let feedbackGenerator = UISelectionFeedbackGenerator()
    private let intervals = [5.0, 10.0, 15.0, 20.0]
    
    var body: some View {
        VStack(spacing: 20) {
            if hasData {
                Button("查看数据详情") {
                    showingDetail = true
                }
                .buttonStyle(.borderedProminent)
                
                VStack(alignment: .leading, spacing: 10) {
                    Text("设置间隔")
                        .font(.headline)
                    
                    Slider(
                        value: $intervalSeconds,
                        in: 0...20,
                        step: 5,
                        onEditingChanged: { editing in
                            if !editing {
                                // 滑动结束时，确保值落在有效的间隔上
                                if intervalSeconds < 5 {
                                    intervalSeconds = 5
                                }
                                
                                // 如果定时器正在运行，更新定时器
                                if isTimerRunning {
                                    restartTimer()
                                }
                            }
                        }
                    )
                    .onChange(of: intervalSeconds) { oldValue, newValue in
                        // 当值变化到整数刻度时触发震感
                        if Int(newValue) % 5 == 0 && Int(oldValue) != Int(newValue) {
                            // 使用 heavy 类型提供更强的震感
                            let impactFeedbackGenerator = UIImpactFeedbackGenerator(style: .heavy)
                            impactFeedbackGenerator.prepare()
                            impactFeedbackGenerator.impactOccurred()
                        }
                    }
                    
                    HStack {
                        ForEach([0, 5, 10, 15, 20], id: \.self) { value in
                            Text("\(value)")
                                .frame(maxWidth: .infinity)
                        }
                    }
                }
                .padding()
                
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
        .onAppear {
            feedbackGenerator.prepare()
        }
    }
    
    private func restartTimer() {
        timer?.cancel()
        
        timer = Timer.publish(every: intervalSeconds, on: .main, in: .common)
            .autoconnect()
            .sink { [self] _ in
                guard isTimerRunning,
                      let currentActivity = activity,
                      !vocabularyItems.isEmpty else {
                    return
                }
                
                currentIndex = (currentIndex + 1) % vocabularyItems.count
                let currentWord = vocabularyItems[currentIndex]
                
                Task { @MainActor in
                    let state = HelloWorldAttributes.ContentState(
                        message: currentWord.word,
                        leftText: currentWord.word,
                        rightText: currentWord.definition,
                        minimalText: "📚",
                        phonetic: currentWord.phonetic,
                        partOfSpeech: currentWord.partOfSpeech,
                        example: currentWord.example
                    )
                    
                    let content = ActivityContent(
                        state: state,
                        staleDate: .now.addingTimeInterval(intervalSeconds)
                    )
                    
                    await currentActivity.update(content)
                    print("更新单词：\(currentWord.word) - \(currentWord.definition)")
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
            minimalText: "📚",
            phonetic: currentWord.phonetic,
            partOfSpeech: currentWord.partOfSpeech,
            example: currentWord.example
        )
        
        let content = ActivityContent(
            state: state, 
            staleDate: .now.addingTimeInterval(24 * 60 * 60)
        )
        
        do {
            activity = try Activity.request(attributes: attributes, content: content)
            print("灵动岛启动成功，开始单词：\(currentWord.word)")
            
            isTimerRunning = true
            restartTimer()
            return true
        } catch {
            print("Error: \(error.localizedDescription)")
            return false
        }
    }
    
    func stopLiveActivity() {
        isTimerRunning = false
        timer?.cancel()
        timer = nil
        
        // 终止所有活动的 Live Activity
        Task {
            // 获取所有正在运行的 Live Activities
            for activity in Activity<HelloWorldAttributes>.activities {
                let state = HelloWorldAttributes.ContentState(
                    message: "再见",
                    leftText: "再见",
                    rightText: "再见",
                    minimalText: "👋",
                    phonetic: "",
                    partOfSpeech: "",
                    example: ""
                )
                let content = ActivityContent(state: state, staleDate: nil)
                await activity.end(content, dismissalPolicy: .immediate)
            }
            
            // 重置当前活动
            self.activity = nil
        }
    }
    
    private func minimizeApp() {
        UIApplication.shared.perform(#selector(NSXPCConnection.suspend))
    }
}

#Preview {
    if #available(iOS 16.1, *) {
        ContentView()
    } else {
        Text("Live Activities are available in iOS 16.1 and later.")
    }
}

