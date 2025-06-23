import 'package:and_drum_pad_flutter/core/utils/locator_support.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ScreenRecorderService {
  static const MethodChannel platform = MethodChannel('screen_recording');

  Future<void> startRecording(BuildContext context, Function() onError) async {
    // try {
    //   await platform.invokeMethod('startRecording');
    //   showToastRecordingState(context: context, isStart: true);
    //   print("Bắt đầu quay màn hình");
    // } on PlatformException catch (e) {
    //   onError();
    // }
  }


  Future<void> stopRecording(BuildContext context) async {
    // try {
    //   final String videoPath = await platform.invokeMethod('stopRecording');
    //   showToastRecordingState(context: context, isStart: false);
    //   print("Video đã lưu tại: $videoPath");
    // } on PlatformException catch (e) {
    //   print("Lỗi: '${e.message}'.");
    // }
  }

  static void showToastRecordingState({required BuildContext context, required bool isStart}){
    // ScaffoldMessenger.of(context).showSnackBar(
    //   SnackBar(
    //     content: Container(
    //       padding: EdgeInsets.all(8),
    //       decoration: BoxDecoration(
    //         borderRadius: BorderRadius.circular(16),
    //         color: Colors.black.withValues(alpha: 0.7)
    //       ),
    //       child: Text(isStart ? context.locale.recording_started : context.locale.recording_saved, style: TextStyle(color: Colors.white, fontSize: 18), textAlign: TextAlign.center,)
    //     ),
    //     duration: Duration(seconds: 1),
    //     backgroundColor: Colors.transparent,
    //     elevation: 0,
    //     behavior: SnackBarBehavior.floating,
    //     width: MediaQuery.of(context).size.width * 0.6,
    //   ),
    // );
  }
}