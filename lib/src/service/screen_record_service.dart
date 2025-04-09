import 'package:flutter/services.dart';

class ScreenRecorderService {
  static const MethodChannel platform = MethodChannel('screen_recording');

  Future<void> startRecording(Function() onError) async {
    try {
      await platform.invokeMethod('startRecording');
      print("Bắt đầu quay màn hình");
    } on PlatformException catch (e) {
      onError();
    }
  }


  Future<void> stopRecording() async {
    try {
      final String videoPath = await platform.invokeMethod('stopRecording');
      print("Video đã lưu tại: $videoPath");
    } on PlatformException catch (e) {
      print("Lỗi: '${e.message}'.");
    }
  }
}