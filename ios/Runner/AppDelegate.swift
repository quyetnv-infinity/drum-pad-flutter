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

    // Bắt đầu ghi âm thanh hệ thống
    func startBroadcastRecording(result: @escaping FlutterResult) {
        let picker = RPSystemBroadcastPickerView(frame: CGRect(x: 0, y: 0, width: 60, height: 60))
        if let url = Bundle.main.url(forResource: "ScreenRecordHandler", withExtension: "appex", subdirectory: "PlugIns") {
            picker.preferredExtension = url.absoluteString
        }
        picker.showsMicrophoneButton = false
        DispatchQueue.main.async {
            self.window?.rootViewController?.view.addSubview(picker)
            picker.subviews.first?.perform(#selector(UIButton.sendActions(for:)), with: UIControl.Event.touchUpInside)
        }
        result(true)
    }

    // Dừng ghi âm thanh hệ thống
    func stopBroadcastRecording(result: @escaping FlutterResult) {
        RPBroadcastActivityViewController.load { (broadcastActivityViewController, error) in
            if let error = error {
                print("❌ Lỗi dừng broadcast: \(error.localizedDescription)")
                result(false)
            } else {
                broadcastActivityViewController?.dismiss(animated: true, completion: nil)
                result(true)
            }
        }
    }
}
