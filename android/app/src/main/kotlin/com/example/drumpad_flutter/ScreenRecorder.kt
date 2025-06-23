package com.example.piano.screenrecord

import android.app.Activity
import android.content.Context
import android.content.Intent
import android.hardware.display.DisplayManager
import android.hardware.display.VirtualDisplay
import android.media.MediaProjection
import android.media.MediaProjectionManager
import android.media.MediaRecorder
import android.os.Environment
import android.util.DisplayMetrics
import android.view.Surface
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.PluginRegistry
import java.io.File

class ScreenRecorder(
    private val activity: Activity,
    private val channel: MethodChannel
) : PluginRegistry.ActivityResultListener {

    private val SCREEN_RECORD_REQUEST_CODE = 1001
    private lateinit var projectionManager: MediaProjectionManager
    private var mediaProjection: MediaProjection? = null
    private var virtualDisplay: VirtualDisplay? = null
    private lateinit var mediaRecorder: MediaRecorder
    private var videoFilePath: String = ""

    init {
        projectionManager = activity.getSystemService(Context.MEDIA_PROJECTION_SERVICE) as MediaProjectionManager
    }

    fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "startRecording" -> {
                requestScreenCapturePermission()
                result.success(null)
            }
            "stopRecording" -> {
                stopScreenRecording()
                result.success(videoFilePath)
            }
            else -> result.notImplemented()
        }
    }

    private fun requestScreenCapturePermission() {
        val captureIntent = projectionManager.createScreenCaptureIntent()
        activity.startActivityForResult(captureIntent, SCREEN_RECORD_REQUEST_CODE)
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?): Boolean {
        if (requestCode == SCREEN_RECORD_REQUEST_CODE && resultCode == Activity.RESULT_OK && data != null) {
            mediaProjection = projectionManager.getMediaProjection(resultCode, data)
            startScreenRecording()
            return true
        }
        return false
    }

    private fun setupMediaRecorder() {
        val directory = activity.getExternalFilesDir(Environment.DIRECTORY_MOVIES)
        videoFilePath = "${directory?.absolutePath}/screen_record_${System.currentTimeMillis()}.mp4"

        mediaRecorder = MediaRecorder().apply {
            setAudioSource(MediaRecorder.AudioSource.MIC)
            setVideoSource(MediaRecorder.VideoSource.SURFACE)
            setOutputFormat(MediaRecorder.OutputFormat.MPEG_4)
            setOutputFile(videoFilePath)
            setVideoSize(720, 1280)
            setVideoEncoder(MediaRecorder.VideoEncoder.H264)
            setAudioEncoder(MediaRecorder.AudioEncoder.AAC)
            setVideoEncodingBitRate(512 * 1000)
            setVideoFrameRate(30)
            prepare()
        }
    }

    private fun startScreenRecording() {
        setupMediaRecorder()

        val metrics = DisplayMetrics()
        activity.windowManager.defaultDisplay.getRealMetrics(metrics)

        virtualDisplay = mediaProjection?.createVirtualDisplay(
            "ScreenRecorder",
            metrics.widthPixels, metrics.heightPixels, metrics.densityDpi,
            DisplayManager.VIRTUAL_DISPLAY_FLAG_AUTO_MIRROR,
            mediaRecorder.surface, null, null
        )

        mediaRecorder.start()
    }

    private fun stopScreenRecording() {
        try {
            virtualDisplay?.release()
            mediaProjection?.stop()
            mediaRecorder.stop()
            mediaRecorder.reset()
        } catch (e: Exception) {
            e.printStackTrace()
        }
    }
}
