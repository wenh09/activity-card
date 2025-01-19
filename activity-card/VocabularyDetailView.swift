import SwiftUI

struct VocabularyDetailView: View {
    let vocabularyItems: [VocabularyItem]
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            VStack {
                Text("加载记录数: \(vocabularyItems.count)")
                    .font(.system(size: 12))
                    .foregroundColor(.gray)
                    .padding(.top)
                
                ScrollView {
                    LazyVStack(alignment: .leading, spacing: 16) {
                        ForEach(vocabularyItems) { item in
                            VStack(alignment: .leading, spacing: 8) {
                                // 第一行：序号｜单词英文｜词性｜音标｜释义
                                Text("\(item.serialNumber) | \(item.word) | \(item.partOfSpeech) | \(item.phonetic) | \(item.definition)")
                                    .font(.system(size: 12))
                                
                                // 第二行：例句
                                Text(item.example)
                                    .font(.system(size: 12))
                            }
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color(uiColor: UIColor.systemGray5))
                            .cornerRadius(8)
                        }
                    }
                    .padding(.horizontal)
                }
            }
            .navigationTitle("托福数据集")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("返回") {
                        dismiss()
                    }
                }
            }
        }
    }
} 