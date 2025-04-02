import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate {
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        GeneratedPluginRegistrant.register(with: self)
        let controller = window?.rootViewController as! FlutterViewController
        let channel = FlutterMethodChannel(name: "screen_recorder", binaryMessenger: controller.binaryMessenger)
        
        channel.setMethodCallHandler { (call, result) in
            switch call.method {
            case "startRecording":
                ScreenRecorder.shared.startRecording { success in
                    DispatchQueue.main.async {
                        result(success)
                    }
                }

            case "stopRecording":
                ScreenRecorder.shared.stopRecording { success, path in
                    DispatchQueue.main.async {
                        result(["success": success, "path": path ?? ""])
                    }
                }

            default:
                result(FlutterMethodNotImplemented)
            }
        }

        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
}
