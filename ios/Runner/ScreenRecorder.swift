import Flutter
import UIKit
import ReplayKit
import Photos

class ScreenRecorder: NSObject, RPScreenRecorderDelegate, RPPreviewViewControllerDelegate {
    static let shared = ScreenRecorder()
    var isRecording = false
    var outputURL: URL?

    func startRecording(result: @escaping (Bool) -> Void) {
        let recorder = RPScreenRecorder.shared()
        guard !recorder.isRecording else {
            result(false)
            return
        }

        let fileName = "screen_recording_\(UUID().uuidString).mov"
        let tempPath = NSTemporaryDirectory().appending(fileName)
        outputURL = URL(fileURLWithPath: tempPath)

        recorder.startRecording { error in
            if let error = error {
                print("Error starting recording: \(error.localizedDescription)")
                result(false)
            } else {
                self.isRecording = true
                result(true)
            }
        }
    }

    func stopRecording(result: @escaping (Bool, String?) -> Void) {
        let recorder = RPScreenRecorder.shared()
        guard recorder.isRecording else {
            result(false, nil)
            return
        }

        recorder.stopRecording { previewController, error in
            if let error = error {
                print("Error stopping recording: \(error.localizedDescription)")
                result(false, nil)
                return
            }

            self.isRecording = false

            if let outputPath = self.outputURL?.path {
                print("Recording finished. Saving to Photos Library...")

                // Yêu cầu quyền lưu vào thư viện ảnh
                PHPhotoLibrary.requestAuthorization { status in
                    if status == .authorized {
                        UISaveVideoAtPathToSavedPhotosAlbum(outputPath, nil, nil, nil)
                        print("✅ Video saved to Photos Library: \(outputPath)")
                        result(true, outputPath)
                    } else {
                        print("❌ Permission denied to save video to Photos Library.")
                        result(false, nil)
                    }
                }
            } else {
                result(false, nil)
            }
        }
    }
}
