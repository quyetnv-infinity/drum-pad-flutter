package com.example.and_drum_pad_flutter

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine

class MainActivity: FlutterActivity(){
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)


        flutterEngine.plugins.add(MediaRecorderPlugin())
        flutterEngine.plugins.add(AudioCapturePlugin())
    }
}
