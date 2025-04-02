import Flutter
import UIKit
import ReplayKit

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
            } else {
                self.isRecording = false
                result(true, self.outputURL?.path)
            }
        }
    }
}
