import ReplayKit
import AVFoundation
import Photos

class ScreenRecordHandler: RPBroadcastSampleHandler {
    static let shared = ScreenRecordHandler()
    
    var assetWriter: AVAssetWriter?
    var videoWriterInput: AVAssetWriterInput?
    var audioWriterInput: AVAssetWriterInput?
    var outputURL: URL?

    override func broadcastStarted(withSetupInfo setupInfo: [String : NSObject]?) {
        print("✅ Bắt đầu quay màn hình + ghi âm thanh hệ thống")

        // 🔹 Tạo đường dẫn file .mp4
        let fileName = "screen_recording_\(UUID().uuidString).mp4"
        let outputPath = NSTemporaryDirectory().appending(fileName)
        outputURL = URL(fileURLWithPath: outputPath)

        do {
            assetWriter = try AVAssetWriter(outputURL: outputURL!, fileType: .mp4)

            // 🔹 Cấu hình video
            let videoSettings: [String: Any] = [
                AVVideoCodecKey: AVVideoCodecType.h264,
                AVVideoWidthKey: 1080,
                AVVideoHeightKey: 1920
            ]
            videoWriterInput = AVAssetWriterInput(mediaType: .video, outputSettings: videoSettings)
            videoWriterInput?.expectsMediaDataInRealTime = true

            // 🔹 Cấu hình audio (chỉ ghi âm thanh hệ thống, không micro)
            let audioSettings: [String: Any] = [
                AVFormatIDKey: kAudioFormatMPEG4AAC,
                AVNumberOfChannelsKey: 2,
                AVSampleRateKey: 44100,
                AVEncoderBitRateKey: 128000
            ]
            audioWriterInput = AVAssetWriterInput(mediaType: .audio, outputSettings: audioSettings)
            audioWriterInput?.expectsMediaDataInRealTime = true

            if let writer = assetWriter {
                if let vInput = videoWriterInput, writer.canAdd(vInput) {
                    writer.add(vInput)
                }
                if let aInput = audioWriterInput, writer.canAdd(aInput) {
                    writer.add(aInput)
                }
                writer.startWriting()
                writer.startSession(atSourceTime: .zero)
                print("✅ Bắt đầu ghi...")
            }
        } catch {
            print("❌ Lỗi khi tạo AVAssetWriter: \(error.localizedDescription)")
        }
    }

    override func broadcastFinished() {
        print("✅ Dừng quay màn hình")

        videoWriterInput?.markAsFinished()
        audioWriterInput?.markAsFinished()
        assetWriter?.finishWriting {
            if let savedURL = self.outputURL {
                print("✅ Video đã lưu tại: \(savedURL.path)")
                self.saveToPhotos(videoURL: savedURL)
            }
        }
    }

    override func processSampleBuffer(_ sampleBuffer: CMSampleBuffer, with sampleBufferType: RPSampleBufferType) {
        switch sampleBufferType {
        case .video:
            if videoWriterInput?.isReadyForMoreMediaData == true {
                videoWriterInput?.append(sampleBuffer)
            }
        case .audioApp: // Ghi âm thanh hệ thống
            if audioWriterInput?.isReadyForMoreMediaData == true {
                audioWriterInput?.append(sampleBuffer)
            }
        default:
            break
        }
    }

    // 🔹 Lưu video vào thư viện Photos
    func saveToPhotos(videoURL: URL) {
        PHPhotoLibrary.requestAuthorization { status in
            if status == .authorized {
                PHPhotoLibrary.shared().performChanges({
                    PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: videoURL)
                }) { success, error in
                    if success {
                        print("✅ Video đã được lưu vào Photos")
                    } else if let error = error {
                        print("❌ Lỗi khi lưu video: \(error.localizedDescription)")
                    }
                }
            } else {
                print("❌ Không có quyền truy cập Photos")
            }
        }
    }
}
