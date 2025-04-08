import SwiftUI

struct ContentView: View {
    @StateObject private var speechRecognizer = SpeechRecognizer()
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Word Count: \(speechRecognizer.wordCount)")
                .font(.largeTitle)
            
            Button(action: {
                speechRecognizer.toggleRecording()
            }) {
                Text(speechRecognizer.isRecording ? "Stop Listening" : "Start Listening")
                    .padding()
                    .background(speechRecognizer.isRecording ? Color.red : Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
        }
        .padding()
    }
}
