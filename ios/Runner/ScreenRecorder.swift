import SwiftUI
import ReplayKit
import AVFoundation
import Photos

class ViewRecorder: ObservableObject {
    private let recorder = RPScreenRecorder.shared()
    
    // MARK: - Các biến liên quan đến AVAssetWriter
    private var assetWriter: AVAssetWriter?
    private var videoInput: AVAssetWriterInput?
    private var audioInput: AVAssetWriterInput?
    
    private var sessionAtSourceTime: CMTime?
    
    private var isWriterReady = false
    
    private var targetView: UIView?
    
    @Published var isRecording = false

    private var outputURL: URL?

    func setTarget(view: UIView) {
        self.targetView = view
    }
    
    private func generateVideoFileURL() -> URL? {
        let cacheDir = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first
        let fileName = "RecordedVideo_\(UUID().uuidString).mp4"
        return cacheDir?.appendingPathComponent(fileName)
    }

    private func setupWriter(from sampleBuffer: CMSampleBuffer) throws {
        guard
            let outputURL = outputURL, // đã được set ở lúc startRecording()
            let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer)
        else {
            throw NSError(domain: "ViewRecorder", code: -4,
                          userInfo: [NSLocalizedDescriptionKey: "Không thể tạo AssetWriter"])
        }
        
        if FileManager.default.fileExists(atPath: outputURL.path) {
            try FileManager.default.removeItem(at: outputURL)
        }

        let width = CVPixelBufferGetWidth(pixelBuffer)
        let height = CVPixelBufferGetHeight(pixelBuffer)

        assetWriter = try AVAssetWriter(outputURL: outputURL, fileType: .mp4)
        
      
        let videoSettings: [String: Any] = [
            AVVideoCodecKey: AVVideoCodecType.h264,
            AVVideoWidthKey: width,
            AVVideoHeightKey: height
        ]
        videoInput = AVAssetWriterInput(mediaType: .video, outputSettings: videoSettings)
        videoInput?.expectsMediaDataInRealTime = true
        
        let audioSettings: [String: Any] = [
            AVFormatIDKey: kAudioFormatMPEG4AAC,
            AVNumberOfChannelsKey: 2,
            AVSampleRateKey: 44100,
            AVEncoderBitRateKey: 128000
        ]
        audioInput = AVAssetWriterInput(mediaType: .audio, outputSettings: audioSettings)
        audioInput?.expectsMediaDataInRealTime = true
        
        // Thêm input
        if let vInput = videoInput, assetWriter?.canAdd(vInput) == true {
            assetWriter?.add(vInput)
        }
        if let aInput = audioInput, assetWriter?.canAdd(aInput) == true {
            assetWriter?.add(aInput)
        }

        sessionAtSourceTime = nil
        isWriterReady = false
    }
    
    // MARK: - startRecording
    func startRecording(completion: @escaping (Error?) -> Void) {
        guard recorder.isAvailable else {
            completion(NSError(domain: "ViewRecorder",
                               code: -1,
                               userInfo: [NSLocalizedDescriptionKey: "ReplayKit không khả dụng"]))
            return
        }
        
        guard let _ = targetView else {
            completion(NSError(domain: "ViewRecorder",
                               code: -2,
                               userInfo: [NSLocalizedDescriptionKey: "Không có view để ghi lại"]))
            return
        }
        
        self.outputURL = generateVideoFileURL()
        
        recorder.startCapture(
            handler: { [weak self] buffer, type, error in
                guard let self = self else { return }
                
                if let error = error {
                    print("Lỗi ghi: \(error.localizedDescription)")
                    return
                }
                
                switch type {
                case .video:
                    if self.assetWriter == nil {
                        do {
                            try self.setupWriter(from: buffer)
                        } catch {
                            print("Lỗi setupWriter: \(error.localizedDescription)")
                            return
                        }
                    }
                    self.appendBuffer(buffer, to: self.videoInput)
                    
                case .audioApp, .audioMic:
                    self.appendBuffer(buffer, to: self.audioInput)
                    
                @unknown default:
                    break
                }
            },
            completionHandler: { [weak self] error in
                DispatchQueue.main.async {
                    guard let self = self else { return }
                    self.isRecording = (error == nil)
                    completion(error)
                }
            }
        )
    }
    
    func stopRecording(completion: @escaping (URL?, Error?) -> Void) {
        recorder.stopCapture { [weak self] error in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.isRecording = false
            }
            
            if let error = error {
                self.finishWritingAndCleanup(url: nil, err: error, completion: completion)
            } else {
                guard let assetWriter = self.assetWriter else {
                    self.finishWritingAndCleanup(
                        url: nil,
                        err: NSError(domain: "ViewRecorder", code: -5,
                                     userInfo: [NSLocalizedDescriptionKey: "Chưa ghi được frame video nào"]),
                        completion: completion
                    )
                    return
                }
                
                assetWriter.finishWriting { [weak self] in
                    guard let self = self else { return }
                    
                    if let writerError = assetWriter.error {
                        self.finishWritingAndCleanup(url: nil, err: writerError, completion: completion)
                    } else {
                        // Trả về URL thành phẩm
                        let finalURL = assetWriter.outputURL
                        self.saveToPhotos(url: finalURL) { error in
                            if let error = error {
                                print("Lỗi khi lưu video vào Photos: \(error.localizedDescription)")
                            } else {
                                print("✅ Video đã được lưu vào thư viện ảnh!")
                            }
                            
                            self.finishWritingAndCleanup(url: finalURL, err: nil, completion: completion)
                        }

                    }
                }
            }
        }
    }
    
    // MARK: - Private Helper
    private func appendBuffer(_ sampleBuffer: CMSampleBuffer, to input: AVAssetWriterInput?) {
        guard
            let input = input,
            let assetWriter = assetWriter,
            assetWriter.status != .failed
        else { return }
        
        if !isWriterReady {
            isWriterReady = true
            sessionAtSourceTime = CMSampleBufferGetPresentationTimeStamp(sampleBuffer)
            assetWriter.startWriting()
            
            if let startTime = sessionAtSourceTime {
                assetWriter.startSession(atSourceTime: startTime)
            }
        }
        
        if input.isReadyForMoreMediaData {
            input.append(sampleBuffer)
        }
    }
    
    private func finishWritingAndCleanup(
        url: URL?,
        err: Error?,
        completion: @escaping (URL?, Error?) -> Void
    ) {
        // Cleanup
        assetWriter = nil
        videoInput = nil
        audioInput = nil
        sessionAtSourceTime = nil
        isWriterReady = false
        outputURL = nil
        
        DispatchQueue.main.async {
            completion(url, err)
        }
    }
    func saveToPhotos(url: URL, completion: @escaping (Error?) -> Void) {
        PHPhotoLibrary.requestAuthorization { status in
            guard status == .authorized || status == .limited else {
                completion(NSError(domain: "ViewRecorder",
                                   code: -1,
                                   userInfo: [NSLocalizedDescriptionKey: "Không có quyền truy cập thư viện ảnh"]))
                return
            }
            
            PHPhotoLibrary.shared().performChanges({
                let creationRequest = PHAssetCreationRequest.forAsset()
                creationRequest.addResource(with: .video, fileURL: url, options: nil)
            }) { success, error in
                DispatchQueue.main.async {
                    completion(error)
                }
            }
        }
    }
}
