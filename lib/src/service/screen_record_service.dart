import 'package:flutter/services.dart';

class ScreenRecorderService {
  static const MethodChannel _channel = MethodChannel('screen_recording');

  Future<String?> startRecording() async {
    try {
      // Yêu cầu phía native bắt đầu ghi
      // Phía native sẽ trả về null nếu bắt đầu thành công, hoặc thông báo lỗi
      final String? result = await _channel.invokeMethod('startRecording');
      if (result != null) {
        print("Bắt đầu ghi thất bại: $result");
        return "Lỗi: $result"; // Trả về lỗi nếu có
      }
      print("Đã bắt đầu ghi màn hình.");
      return null; // Bắt đầu thành công
    } on PlatformException catch (e) {
      print("Lỗi khi gọi startRecording: ${e.message}");
      return "Lỗi Platform: ${e.message}";
    }
  }

  Future<String?> stopRecording() async {
    try {
      // Yêu cầu phía native dừng ghi và trả về đường dẫn file
      final String? filePath = await _channel.invokeMethod('stopRecording');
      if (filePath != null) {
        print("Đã dừng ghi. File lưu tại: $filePath");
        return filePath; // Trả về đường dẫn file
      } else {
        print("Dừng ghi thất bại hoặc không có file nào được tạo.");
        return null;
      }
    } on PlatformException catch (e) {
      print("Lỗi khi gọi stopRecording: ${e.message}");
      return "Lỗi Platform: ${e.message}";
    }
  }
}