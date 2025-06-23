package com.example.drumpad_flutter

import io.flutter.embedding.android.FlutterActivity

class MainActivity: FlutterActivity(){
    private lateinit var recorder: ScreenRecorder

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        val channel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "screen_recording")
        recorder = ScreenRecorder(this, channel)

        channel.setMethodCallHandler { call, result ->
            recorder.onMethodCall(call, result)
        }

        // Register Activity Result Listener
        flutterEngine.activityControlSurface.attachToActivity(this, lifecycle)
        flutterEngine.activityControlSurface.addActivityResultListener(recorder)
    }
}
