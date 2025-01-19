struct VocabularyItem: Identifiable, Codable {
    let id: Int
    let serialNumber: String    // 序号
    let word: String           // 单词
    let definition: String     // 释义
    let partOfSpeech: String   // 词性
    let phonetic: String       // 音标
    let example: String        // 例句
    
    init(id: Int, serialNumber: String, word: String, definition: String, partOfSpeech: String, phonetic: String, example: String) {
        self.id = id
        self.serialNumber = serialNumber.isEmpty ? "0" : serialNumber
        self.word = word.isEmpty ? "未知单词" : word
        self.definition = definition.isEmpty ? "暂无释义" : definition
        self.partOfSpeech = partOfSpeech.isEmpty ? "未知词性" : partOfSpeech
        self.phonetic = phonetic.isEmpty ? "暂无音标" : phonetic
        self.example = example.isEmpty ? "暂无例句" : example
    }
} 