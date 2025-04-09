import SwiftUI

struct ContentView: View {
    @StateObject private var recognizer = SpeechRecognizer()
    @State private var wordCount = 0

    var body: some View {
        VStack(spacing: 20) {
            Text("Слов: \(wordCount)")
                .font(.largeTitle)

            Button(action: {
                if recognizer.isListening {
                    recognizer.stopTranscribing()
                } else {
                    recognizer.startTranscribing { text in
                        let words = text.split(separator: " ")
                        wordCount = words.count
                    }
                }
            }) {
                Text(recognizer.isListening ? "Остановить" : "Начать")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
        }
        .padding()
    }
}