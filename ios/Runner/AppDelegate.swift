import UIKit
import Flutter
import ReplayKit
import AVFoundation
import ads_tracking_plugin
import google_mobile_ads

@main
@objc class AppDelegate: FlutterAppDelegate {
    let recorder = ViewRecorder()
    
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        GeneratedPluginRegistrant.register(with: self)
        let controller = window?.rootViewController as! FlutterViewController
        recorder.setTarget(view: controller.view)
                let methodChannel = FlutterMethodChannel(name: "screen_recording", binaryMessenger: controller.binaryMessenger)

                methodChannel.setMethodCallHandler { [weak self] (call, result) in
                    guard let self = self else { return }

                    switch call.method {
                    case "startRecording":
                        self.recorder.startRecording { error in  // 🛠 Thêm 'self.' để gọi đúng biến
                            if let error = error {
                                result(FlutterError(code: "START_FAILED", message: error.localizedDescription, details: nil))
                            } else {
                                result("Recording started")
                            }
                        }
                        
                    case "stopRecording":
                        self.recorder.stopRecording { url, error in
                            if let error = error {
                                result(FlutterError(code: "STOP_FAILED", message: error.localizedDescription, details: nil))
                            } else if let url = url {
                                result(url.absoluteString)
                            } else {
                                result(FlutterError(code: "NO_OUTPUT", message: "Không có video được tạo", details: nil))
                            }
                        }
                        
                    default:
                        result(FlutterMethodNotImplemented)
                    }
                }
        // Initialize Google Mobile Ads SDK
        GADMobileAds.sharedInstance().start(completionHandler: nil)
        // Register NativeAdFactoryExample

        let layoutTopCTA = LayoutTopCTA()
        let layoutAdLarge = LayoutAdLarge()

        FLTGoogleMobileAdsPlugin.registerNativeAdFactory(
          self,
          factoryId: "layoutTopCTA",
          nativeAdFactory: layoutTopCTA
        )

        FLTGoogleMobileAdsPlugin.registerNativeAdFactory(
          self,
          factoryId: "layoutAdLarge",
          nativeAdFactory: layoutAdLarge
        )

    
       
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
}
