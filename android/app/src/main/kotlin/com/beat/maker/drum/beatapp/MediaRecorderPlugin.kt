package com.beat.maker.drum.beatapp


import android.media.MediaRecorder
import android.os.Environment
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import java.io.File
import java.io.IOException
import android.content.Context

class MediaRecorderPlugin: FlutterPlugin, MethodCallHandler {
    private lateinit var channel: MethodChannel
    private var mediaRecorder: MediaRecorder? = null
    private var isRecording = false
    private var outputFile: File? = null
    private lateinit var context: Context

    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(binding.binaryMessenger, "media_recorder")
        channel.setMethodCallHandler(this)
        context = binding.applicationContext
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        when (call.method) {
            "startRecording" -> {
                startRecording(result)
            }
            "stopRecording" -> {
                stopRecording(result)
            }
            "pauseRecording" -> {
                pauseRecording(result)
            }
            "resumeRecording" -> {
                resumeRecording(result)
            }
            "getRecordedFiles" -> {
                getRecordedFiles(result)
            }
            "deleteFile" -> {
                val filePath = call.argument<String>("filePath")
                deleteFile(filePath, result)
            }
            else -> {
                result.notImplemented()
            }
        }
    }

    private fun startRecording(result: Result) {
        try {
            if (isRecording) {
                result.error("ALREADY_RECORDING", "Recording is already in progress", null)
                return
            }

            // Tạo file output trong thư mục app
//            val fileName = "app_audio_${System.currentTimeMillis()}.mp3"
//            val appDir = File(context.getExternalFilesDir(null), "recordings")
//            if (!appDir.exists()) {
//                appDir.mkdirs()
//            }
            // Lưu vào thư mục công khai: Music/DrumPad/
            val musicDir = Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_MUSIC)
            val appDir = File(musicDir, "DrumPad")

            // Tạo thư mục nếu chưa có
            if (!appDir.exists()) {
                val created = appDir.mkdirs()
                if (!created) {
                    result.error("DIR_ERROR", "Failed to create output directory", null)
                    return
                }
            }

            // Tạo file mới
            val fileName = "app_audio_${System.currentTimeMillis()}.mp3"
            outputFile = File(appDir, fileName)

//            outputFile = File(appDir, fileName)

            // Khởi tạo MediaRecorder
            mediaRecorder = MediaRecorder().apply {
                setAudioSource(MediaRecorder.AudioSource.MIC)
                setOutputFormat(MediaRecorder.OutputFormat.MPEG_4)
                setAudioEncoder(MediaRecorder.AudioEncoder.AAC)
                setAudioEncodingBitRate(128000)
                setAudioSamplingRate(44100)
                setOutputFile(outputFile?.absolutePath)

                try {
                    prepare()
                    start()
                    isRecording = true
                    result.success(mapOf(
                        "message" to "Recording started successfully",
                        "filePath" to outputFile?.absolutePath
                    ))
                } catch (e: IOException) {
                    result.error("PREPARE_ERROR", "Failed to prepare MediaRecorder: ${e.message}", null)
                }
            }

        } catch (e: Exception) {
            result.error("RECORDING_ERROR", "Failed to start recording: ${e.message}", null)
        }
    }

    private fun stopRecording(result: Result) {
        try {
            if (!isRecording) {
                result.error("NOT_RECORDING", "No recording in progress", null)
                return
            }

            mediaRecorder?.apply {
                stop()
                release()
            }
            mediaRecorder = null
            isRecording = false

            val filePath = outputFile?.absolutePath
            result.success(mapOf(
                "message" to "Recording stopped successfully",
                "filePath" to filePath,
                "fileSize" to outputFile?.length()
            ))

        } catch (e: Exception) {
            result.error("STOP_ERROR", "Failed to stop recording: ${e.message}", null)
        }
    }

    private fun pauseRecording(result: Result) {
        try {
            if (!isRecording) {
                result.error("NOT_RECORDING", "No recording in progress", null)
                return
            }

            if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.N) {
                mediaRecorder?.pause()
                result.success("Recording paused successfully")
            } else {
                result.error("VERSION_ERROR", "Pause not supported on this Android version", null)
            }

        } catch (e: Exception) {
            result.error("PAUSE_ERROR", "Failed to pause recording: ${e.message}", null)
        }
    }

    private fun resumeRecording(result: Result) {
        try {
            if (!isRecording) {
                result.error("NOT_RECORDING", "No recording in progress", null)
                return
            }

            if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.N) {
                mediaRecorder?.resume()
                result.success("Recording resumed successfully")
            } else {
                result.error("VERSION_ERROR", "Resume not supported on this Android version", null)
            }

        } catch (e: Exception) {
            result.error("RESUME_ERROR", "Failed to resume recording: ${e.message}", null)
        }
    }

    private fun getRecordedFiles(result: Result) {
        try {
            val appDir = File(context.getExternalFilesDir(null), "recordings")
            if (!appDir.exists()) {
                result.success(emptyList<Map<String, Any>>())
                return
            }

            val files = appDir.listFiles { file ->
                file.name.startsWith("app_audio_") &&
                        (file.extension == "mp3" || file.extension == "m4a" || file.extension == "wav")
            }

            val fileList = files?.map { file ->
                mapOf(
                    "name" to file.name,
                    "path" to file.absolutePath,
                    "size" to file.length(),
                    "sizeInMB" to String.format("%.2f", file.length() / (1024 * 1024.0)),
                    "lastModified" to file.lastModified(),
                    "extension" to file.extension
                )
            }?.sortedByDescending { it["lastModified"] as Long } ?: emptyList()

            result.success(fileList)

        } catch (e: Exception) {
            result.error("FILE_ERROR", "Failed to get recorded files: ${e.message}", null)
        }
    }

    private fun deleteFile(filePath: String?, result: Result) {
        try {
            if (filePath == null) {
                result.error("INVALID_PATH", "File path is null", null)
                return
            }

            val file = File(filePath)
            if (file.exists()) {
                val deleted = file.delete()
                if (deleted) {
                    result.success("File deleted successfully")
                } else {
                    result.error("DELETE_ERROR", "Failed to delete file", null)
                }
            } else {
                result.error("FILE_NOT_FOUND", "File does not exist", null)
            }

        } catch (e: Exception) {
            result.error("DELETE_ERROR", "Failed to delete file: ${e.message}", null)
        }
    }
}