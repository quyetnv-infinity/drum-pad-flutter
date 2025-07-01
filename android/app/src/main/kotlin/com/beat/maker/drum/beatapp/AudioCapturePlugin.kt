// android/app/src/main/kotlin/com/example/and_drum_pad_flutter/AudioCapturePlugin.kt

package com.beat.maker.drum.beatapp


import android.app.Activity
import android.content.Context
import android.content.Intent
import android.media.projection.MediaProjection
import android.media.projection.MediaProjectionManager
import android.os.Build
import androidx.annotation.NonNull
import androidx.annotation.RequiresApi
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import com.beat.maker.drum.beatapp.AudioCaptureHolder

@RequiresApi(Build.VERSION_CODES.Q)

class AudioCapturePlugin : FlutterPlugin, MethodChannel.MethodCallHandler, ActivityAware {
    private lateinit var channel: MethodChannel
    private lateinit var context: Context
    private var activity: Activity? = null

    private val REQUEST_CODE = 1001
    private var pendingResult: MethodChannel.Result? = null
    private var mediaProjectionManager: MediaProjectionManager? = null

    override fun onAttachedToEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        context = binding.applicationContext
        channel = MethodChannel(binding.binaryMessenger, "capture_audio")
        channel.setMethodCallHandler(this)
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        activity = binding.activity
        binding.addActivityResultListener { requestCode, resultCode, data ->
            if (requestCode == REQUEST_CODE && resultCode == Activity.RESULT_OK && data != null) {
                // ❗Không gọi getMediaProjection ở đây!

                val intent = Intent(context, AudioCaptureService::class.java).apply {
                    putExtra("resultCode", resultCode)
                    putExtra("data", data)
                }

                context.startForegroundService(intent) // ✅ Gọi ngay service
                pendingResult?.success(null)
            } else {
                pendingResult?.error("CANCELLED", "User denied permission", null)
            }
            true
        }
    }



    override fun onDetachedFromActivity() { activity = null }
    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) = onAttachedToActivity(binding)
    override fun onDetachedFromActivityForConfigChanges() = onDetachedFromActivity()

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "startRecording" -> {
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
                    mediaProjectionManager = context.getSystemService(Context.MEDIA_PROJECTION_SERVICE) as MediaProjectionManager
                    val intent = mediaProjectionManager!!.createScreenCaptureIntent()
                    pendingResult = result
                    activity?.startActivityForResult(intent, REQUEST_CODE)
                } else {
                    result.error("UNSUPPORTED", "Android 10+ required", null)
                }
            }

            "stopRecording" -> {
                val stopIntent = Intent(context, AudioCaptureService::class.java)
                context.stopService(stopIntent)
                result.success(null)
            }

            else -> result.notImplemented()
        }
    }
}
