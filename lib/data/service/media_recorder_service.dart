import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';

class MediaRecorderService {
  static const MethodChannel _channel = MethodChannel('media_recorder');
  static const MethodChannel _audioChannel = MethodChannel('capture_audio');

  static Future<void> startInternalRecording() async {
    await _audioChannel.invokeMethod("startRecording");
  }

  static Future<void> stopInternalRecording() async {
    await _audioChannel.invokeMethod("stopRecording");
  }
  // Kiểm tra và yêu cầu quyền
  static Future<bool> requestPermissions() async {
    final permissions = [
      Permission.microphone,
    ];

    final statuses = await permissions.request();

    final micGranted = statuses[Permission.microphone] == PermissionStatus.granted;

    print('Microphone granted: $micGranted');

    return micGranted;
  }


  // Bắt đầu ghi âm
  static Future<Map<String, dynamic>?> startRecording() async {
    try {
      final hasPermission = await requestPermissions();
      if (!hasPermission) {
        print('Permissions not granted');
        return null;
      }

      final result = await _channel.invokeMethod('startRecording');
      print('Recording started: $result');
      return result as Map<String, dynamic>?;
    } catch (e) {
      print('Error starting recording: $e');
      return null;
    }
  }

  // Dừng ghi âm
  static Future<Map<String, dynamic>?> stopRecording() async {
    try {
      final result = await _channel.invokeMethod('stopRecording');
      print('Recording stopped: $result');
      return result as Map<String, dynamic>?;
    } catch (e) {
      print('Error stopping recording: $e');
      return null;
    }
  }

  // Lấy danh sách file đã ghi
  static Future<List<Map<String, dynamic>>> getRecordedFiles() async {
    try {
      final result = await _channel.invokeMethod('getRecordedFiles');
      if (result is List) {
        return result.cast<Map<String, dynamic>>();
      }
      return [];
    } catch (e) {
      print('Error getting recorded files: $e');
      return [];
    }
  }


  // Reset recording state
  static Future<bool> resetRecordingState() async {
    try {
      final result = await _channel.invokeMethod('resetRecordingState');
      print('Recording state reset: $result');
      return true;
    } catch (e) {
      print('Error resetting recording state: $e');
      return false;
    }
  }
}