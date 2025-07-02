import 'package:and_drum_pad_flutter/core/utils/locator_support.dart';
import 'package:flutter/material.dart';

enum RecordStatus { start, stop }

class SnackBarNotification {
  static void show(BuildContext context, RecordStatus status) {
    final isStart = status == RecordStatus.start;

    final snackBar = SnackBar(
      content: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            isStart ? Icons.mic : Icons.stop,
            color: Colors.white,
          ),
          const SizedBox(width: 8),
          Text(
            textAlign: TextAlign.center,
            isStart ? context.locale.recording_started : context.locale.recording_stopped ,
            style: TextStyle(fontSize: 14, color: Colors.white),
          ),
        ],
      ),
      backgroundColor: Colors.black.withValues(alpha: 0.4),
      duration: const Duration(seconds: 1),
      dismissDirection: DismissDirection.vertical,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
