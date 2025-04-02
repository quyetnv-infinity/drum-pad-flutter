import ReplayKit
import AVFoundation

class ScreenRecordHandler: RPBroadcastSampleHandler {
    var audioWriter: AVAssetWriter?
    var audioWriterInput: AVAssetWriterInput?
    var outputURL: URL?

    override func broadcastStarted(withSetupInfo setupInfo: [String : NSObject]?) {
        print("✅ Bắt đầu ghi âm thanh hệ thống")

        // Tạo đường dẫn file .m4a
        let fileName = "system_audio_\(UUID().uuidString).m4a"
        let outputPath = NSTemporaryDirectory().appending(fileName)
        outputURL = URL(fileURLWithPath: outputPath)

        do {
            audioWriter = try AVAssetWriter(outputURL: outputURL!, fileType: .m4a)
            let settings: [String: Any] = [
                AVFormatIDKey: kAudioFormatMPEG4AAC,
                AVNumberOfChannelsKey: 2,
                AVSampleRateKey: 44100,
                AVEncoderBitRateKey: 128000
            ]
            audioWriterInput = AVAssetWriterInput(mediaType: .audio, outputSettings: settings)
            audioWriterInput?.expectsMediaDataInRealTime = true

            if let writer = audioWriter, let input = audioWriterInput, writer.canAdd(input) {
                writer.add(input)
                writer.startWriting()
                writer.startSession(atSourceTime: .zero)
                print("✅ Ghi âm thanh hệ thống...")
            }
        } catch {
            print("❌ Lỗi khi tạo AVAssetWriter: \(error.localizedDescription)")
        }
    }

    override func broadcastFinished() {
        print("✅ Dừng ghi âm thanh hệ thống")

        audioWriterInput?.markAsFinished()
        audioWriter?.finishWriting {
            if let savedURL = self.outputURL {
                print("✅ File âm thanh đã lưu tại: \(savedURL.path)")
            }
        }
    }

    override func processSampleBuffer(_ sampleBuffer: CMSampleBuffer, with sampleBufferType: RPSampleBufferType) {
        if sampleBufferType == .audioApp {
            if audioWriterInput?.isReadyForMoreMediaData == true {
                audioWriterInput?.append(sampleBuffer)
            }
        }
    }
}
