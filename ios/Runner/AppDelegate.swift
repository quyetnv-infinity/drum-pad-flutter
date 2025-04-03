import Flutter
import UIKit
import ReplayKit
import AVFoundation

@main
@objc class AppDelegate: FlutterAppDelegate {
    private var screenRecorder = ScreenRecorder()
    
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        GeneratedPluginRegistrant.register(with: self)
        
        guard let controller = window?.rootViewController as? FlutterViewController else {
            fatalError("rootViewController is not type FlutterViewController")
        }
        
        let recorderChannel = FlutterMethodChannel(name: "com.yourcompany/screen_recorder",
                                                   binaryMessenger: controller.binaryMessenger)
        
        recorderChannel.setMethodCallHandler({
            [weak self] (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
            guard let self = self else { return }
            
            switch call.method {
            case "startRecording":
                self.screenRecorder.startRecording { error in
                    if let error = error {
                        // Có lỗi khi bắt đầu
                        print("Lỗi khi bắt đầu ghi: \(error.localizedDescription)")
                        result("Lỗi: \(error.localizedDescription)") // Trả lỗi về Flutter
                    } else {
                        // Bắt đầu thành công
                        print("Native: Bắt đầu ghi thành công")
                        result(nil) // Trả nil về Flutter để báo thành công
                    }
                }
            case "stopRecording":
                self.screenRecorder.stopRecording { fileURL, error in
                    if let error = error {
                        print("Lỗi khi dừng ghi: \(error.localizedDescription)")
                        result(FlutterError(code: "STOP_FAILED", message: error.localizedDescription, details: nil))
                    } else if let url = fileURL {
                        print("Native: Dừng ghi thành công. File: \(url.path)")
                        result(url.path) // Trả đường dẫn file về Flutter
                    } else {
                        print("Native: Dừng ghi nhưng không có URL.")
                        result(nil) // Không có lỗi nhưng cũng không có file
                    }
                }
            default:
                result(FlutterMethodNotImplemented)
            }
        })
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
}
