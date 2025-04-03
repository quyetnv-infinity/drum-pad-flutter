import ReplayKit
import AVFoundation

class ScreenRecorder {
    private let recorder = RPScreenRecorder.shared()
    private var assetWriter: AVAssetWriter?
    private var videoInput: AVAssetWriterInput?
    private var audioAppInput: AVAssetWriterInput? // Input cho âm thanh ứng dụng
    private var outputURL: URL?
    private var isRecording = false

    func startRecording(completion: @escaping (Error?) -> Void) {
        guard recorder.isAvailable else {
            completion(NSError(domain: "ScreenRecorder", code: -1, userInfo: [NSLocalizedDescriptionKey: "ReplayKit không khả dụng"]))
            return
        }

        guard !isRecording else {
            completion(NSError(domain: "ScreenRecorder", code: -2, userInfo: [NSLocalizedDescriptionKey: "Đã đang trong quá trình ghi"]))
            return
        }

        let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let timestamp = Int(Date().timeIntervalSince1970)
        outputURL = documentsPath.appendingPathComponent("recording-\(timestamp).mp4")

        guard let url = outputURL else {
            completion(NSError(domain: "ScreenRecorder", code: -3, userInfo: [NSLocalizedDescriptionKey: "Không thể tạo đường dẫn file output"]))
            return
        }

        do {
            assetWriter = try AVAssetWriter(outputURL: url, fileType: .mp4)

            let videoOutputSettings: [String: Any] = [
                AVVideoCodecKey: AVVideoCodecType.h264,
                AVVideoWidthKey: UIScreen.main.bounds.size.width * UIScreen.main.scale,
                AVVideoHeightKey: UIScreen.main.bounds.size.height * UIScreen.main.scale,
            ]
            videoInput = AVAssetWriterInput(mediaType: .video, outputSettings: videoOutputSettings)
            videoInput?.expectsMediaDataInRealTime = true
            if let input = videoInput, assetWriter!.canAdd(input) {
                assetWriter!.add(input)
                print("Đã thêm video input")
            } else {
                throw NSError(domain: "ScreenRecorder", code: -4, userInfo: [NSLocalizedDescriptionKey: "Không thể thêm video input vào writer"])
            }

            // Cấu hình audioAppInput trước khi bắt đầu ghi
            audioAppInput = AVAssetWriterInput(mediaType: .audio, outputSettings: nil)
            audioAppInput?.expectsMediaDataInRealTime = true
            if let input = audioAppInput, assetWriter!.canAdd(input) {
                assetWriter!.add(input)
                print("Đã thêm audio app input")
            } else {
                throw NSError(domain: "ScreenRecorder", code: -5, userInfo: [NSLocalizedDescriptionKey: "Không thể thêm audio app input vào writer"])
            }

            // Bắt đầu ghi
            recorder.startCapture(handler: { [weak self] (sampleBuffer, bufferType, error) in
                guard let self = self else { return }

                if let error = error {
                    print("Lỗi trong quá trình capture: \(error.localizedDescription)")
                    return
                }

                guard let writer = self.assetWriter, writer.status == .writing || writer.status == .unknown else {
                    return
                }

                if writer.status == .unknown {
                    writer.startWriting()
                    writer.startSession(atSourceTime: CMSampleBufferGetPresentationTimeStamp(sampleBuffer))
                }

                switch bufferType {
                case .video:
                    if let input = self.videoInput, input.isReadyForMoreMediaData {
                        input.append(sampleBuffer)
                    }
                case .audioApp:
                                if let input = self.audioAppInput {
                                    if input.outputSettings == nil {
                                        if let formatDesc = CMSampleBufferGetFormatDescription(sampleBuffer) {
                                            var acl = AudioChannelLayout()
                                            memset(&acl, 0, MemoryLayout<AudioChannelLayout>.size)
                                            acl.mChannelLayoutTag = kAudioChannelLayoutTag_Mono;

                                            let audioSettings = [
                                                AVFormatIDKey: kAudioFormatMPEG4AAC,
                                                AVSampleRateKey: CMSampleBufferGetFormatDescription(sampleBuffer)?.audioStreamBasicDescription?.mSampleRate ?? 44100,
                                                AVNumberOfChannelsKey: 1,
                                                AVChannelLayoutKey: Data(bytes: &acl, count: MemoryLayout<AudioChannelLayout>.size)
                                            ]

                                            self.audioAppInput = AVAssetWriterInput(mediaType: .audio, outputSettings: audioSettings)
                                            self.audioAppInput?.expectsMediaDataInRealTime = true
                                            print("Đã cấu hình audio settings từ sample buffer.")
                                        }
                                    }

                                    if input.isReadyForMoreMediaData {
                                        input.append(sampleBuffer)
                                    }
                                }
                case .audioMic:
                    break
                @unknown default:
                    print("Unknown buffer type: \(bufferType.rawValue)")
                    break
                }
            }) { [weak self] (error) in
                guard let self = self else { return }
                if let error = error {
                    print("Lỗi khi gọi startCapture: \(error.localizedDescription)")
                    self.cleanupWriter()
                    self.isRecording = false
                    completion(error)
                } else {
                    print("Native: startCapture đã bắt đầu thành công.")
                    self.isRecording = true
                    completion(nil)
                }
            }
        } catch {
            print("Lỗi khởi tạo AVAssetWriter hoặc Input: \(error.localizedDescription)")
            cleanupWriter()
            completion(error)
        }
    }


    // Hàm dừng ghi
    func stopRecording(completion: @escaping (URL?, Error?) -> Void) {
        guard isRecording else {
            print("Không có gì đang được ghi.")
            completion(nil, NSError(domain: "ScreenRecorder", code: -6, userInfo: [NSLocalizedDescriptionKey: "Không có quá trình ghi nào đang chạy"]))
            return
        }

        print("Native: Gọi stopCapture...")
        recorder.stopCapture { [weak self] (error) in
            guard let self = self else { return }
            print("Native: stopCapture completion handler được gọi.")

            if let error = error {
                print("Lỗi khi gọi stopCapture: \(error.localizedDescription)")
                self.cleanupWriter()
                self.isRecording = false
                completion(nil, error)
                return
            }

            // Đánh dấu hoàn thành cho các input
            self.videoInput?.markAsFinished()
            self.audioAppInput?.markAsFinished()

             guard let writer = self.assetWriter else {
                  print("AssetWriter không tồn tại khi dừng.")
                  self.isRecording = false
                  completion(nil, NSError(domain: "ScreenRecorder", code: -7, userInfo: [NSLocalizedDescriptionKey: "AssetWriter không tồn tại"]))
                  return
             }

            // Hoàn thành việc ghi file
            print("Native: Gọi finishWriting...")
             writer.finishWriting { [weak self] in
                 guard let self = self else { return }
                 print("Native: finishWriting completion handler được gọi. Status: \(writer.status.rawValue)")
                 self.isRecording = false // Đặt lại trạng thái

                 if writer.status == .completed {
                     print("Ghi file thành công: \(self.outputURL?.path ?? "Không có URL")")
                     completion(self.outputURL, nil)
                 } else {
                     let writeError = writer.error ?? NSError(domain: "ScreenRecorder", code: -8, userInfo: [NSLocalizedDescriptionKey: "Ghi file thất bại với status \(writer.status.rawValue)"])
                     print("Ghi file thất bại: \(writeError.localizedDescription)")
                     completion(nil, writeError)
                 }
                 // Dọn dẹp writer và các input sau khi hoàn tất (dù thành công hay thất bại)
                 self.cleanupWriter()
            }
        }
    }

    // Hàm dọn dẹp
    private func cleanupWriter() {
        print("Dọn dẹp writer...")
        assetWriter = nil
        videoInput = nil
        audioAppInput = nil
        outputURL = nil // Có thể giữ lại URL nếu cần truy cập sau khi lỗi
    }
}
