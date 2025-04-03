import Flutter
import UIKit
import ReplayKit

@main
@objc class AppDelegate: FlutterAppDelegate {
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        GeneratedPluginRegistrant.register(with: self)
        
        let controller = window?.rootViewController as! FlutterViewController
                let methodChannel = FlutterMethodChannel(name: "screen_audio_recorder",
                                                         binaryMessenger: controller.binaryMessenger)

                methodChannel.setMethodCallHandler { [weak self] (call, result) in
                    if call.method == "startRecording" {
                        self?.startBroadcastRecording(result: result)
                    } else if call.method == "stopRecording" {
                        self?.stopBroadcastRecording(result: result)
                    } else {
                        result(FlutterMethodNotImplemented)
                    }
                }

                return super.application(application, didFinishLaunchingWithOptions: launchOptions)
            }

            func startBroadcastRecording(result: @escaping FlutterResult) {
                RPBroadcastActivityViewController.load { broadcastActivityViewController, error in
                    if let error = error {
                        print("❌ Lỗi khi tải BroadcastActivityViewController: \(error.localizedDescription)")
                        result(false)
                        return
                    }
                    
                    if let broadcastVC = broadcastActivityViewController {
                        broadcastVC.delegate = self
                        DispatchQueue.main.async {
                            self.window?.rootViewController?.present(broadcastVC, animated: true, completion: nil)
                        }
                        result(true)
                    } else {
                        result(false)
                    }
                }
            }

            func stopBroadcastRecording(result: @escaping FlutterResult) {
                RPScreenRecorder.shared().stopCapture { error in
                    if let error = error {
                        print("❌ Lỗi dừng ghi âm: \(error.localizedDescription)")
                        result(false)
                    } else {
                        print("✅ Ghi âm đã dừng")
                        result(true)
                    }
                }
            }
}
