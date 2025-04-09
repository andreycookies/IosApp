import Foundation
import Speech

class SpeechRecognizer: ObservableObject {
    private let recognizer = SFSpeechRecognizer(locale: Locale(identifier: "ru-RU"))
    private var request: SFSpeechAudioBufferRecognitionRequest?
    private var task: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()

    @Published var isListening = false

    func startTranscribing(onUpdate: @escaping (String) -> Void) {
        SFSpeechRecognizer.requestAuthorization { authStatus in
            guard authStatus == .authorized else { return }

            DispatchQueue.main.async {
                self.isListening = true
                self.request = SFSpeechAudioBufferRecognitionRequest()

                guard let request = self.request else { return }

                let inputNode = self.audioEngine.inputNode
                let recordingFormat = inputNode.outputFormat(forBus: 0)
                inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) {
                    buffer, _ in
                    request.append(buffer)
                }

                self.audioEngine.prepare()
                try? self.audioEngine.start()

                self.task = self.recognizer?.recognitionTask(with: request) { result, error in
                    if let result = result {
                        onUpdate(result.bestTranscription.formattedString)
                    }

                    if error != nil {
                        self.stopTranscribing()
                    }
                }
            }
        }
    }

    func stopTranscribing() {
        audioEngine.stop()
        audioEngine.inputNode.removeTap(onBus: 0)
        request?.endAudio()
        task?.cancel()
        isListening = false
    }
}