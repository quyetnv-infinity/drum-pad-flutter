// android/app/src/main/kotlin/com/example/and_drum_pad_flutter/AudioCaptureService.kt

package com.example.and_drum_pad_flutter

import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.Service
import android.content.Context
import android.content.Intent
import android.media.*
import android.media.projection.MediaProjection
import android.os.Build
import android.os.Environment
import android.os.IBinder
import android.util.Log
import androidx.annotation.RequiresApi
import java.io.File
import java.io.FileOutputStream
import android.app.Activity
import android.media.projection.MediaProjectionManager
import java.io.FileInputStream

@RequiresApi(Build.VERSION_CODES.Q)
class AudioCaptureService : Service() {
    private var recorder: AudioRecord? = null
    private var isRecording = false
    private lateinit var recordingThread: Thread
    private var mediaProjection: MediaProjection? = null
    private var pcmFilePath: String? = null
    private var wavFilePath: String? = null

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        startForegroundService() // ✅ Gọi foreground NGAY LẬP TỨC trước khi làm gì khác

        val resultCode = intent?.getIntExtra("resultCode", Activity.RESULT_CANCELED) ?: return START_NOT_STICKY
        val data = intent.getParcelableExtra<Intent>("data") ?: return START_NOT_STICKY

        val projectionManager = getSystemService(Context.MEDIA_PROJECTION_SERVICE) as MediaProjectionManager
        mediaProjection = projectionManager.getMediaProjection(resultCode, data) // ✅ Gọi ở đây

        if (mediaProjection == null) {
            stopSelf()
            return START_NOT_STICKY
        }

        startRecording()
        return START_NOT_STICKY
    }

    private fun startForegroundService() {
        val channelId = "audio_capture_channel"
        val manager = getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val channel = NotificationChannel(
                channelId,
                "Audio Capture",
                NotificationManager.IMPORTANCE_LOW
            )
            manager.createNotificationChannel(channel)
        }

        val notification = Notification.Builder(this, channelId)
            .setContentTitle("Đang ghi âm nội bộ")
            .setContentText("Ứng dụng đang ghi âm thanh nội bộ")
            .setSmallIcon(android.R.drawable.ic_btn_speak_now)
            .build()

        startForeground(1, notification)
    }

    private fun startRecording() {
        val config = AudioPlaybackCaptureConfiguration.Builder(mediaProjection!!)
            .addMatchingUsage(AudioAttributes.USAGE_MEDIA)
            .build()

        val format = AudioFormat.Builder()
            .setEncoding(AudioFormat.ENCODING_PCM_16BIT)
            .setSampleRate(44100)
            .setChannelMask(AudioFormat.CHANNEL_IN_STEREO)
            .build()

        val bufferSize = AudioRecord.getMinBufferSize(
            44100, AudioFormat.CHANNEL_IN_STEREO, AudioFormat.ENCODING_PCM_16BIT
        )

        recorder = AudioRecord.Builder()
            .setAudioFormat(format)
            .setBufferSizeInBytes(bufferSize)
            .setAudioPlaybackCaptureConfig(config)
            .build()

        val fileName = "app_audio_${System.currentTimeMillis()}"
        pcmFilePath = File(getExternalFilesDir(null), "$fileName.pcm").absolutePath
        wavFilePath = File(getExternalFilesDir(null), "$fileName.wav").absolutePath
        val pcmFile = File(pcmFilePath!!)
        var pcmOutputStream: FileOutputStream? = null
        try {
            pcmOutputStream = FileOutputStream(pcmFile)
        } catch (e: Exception) {
            Log.e("AudioCaptureService", "PCM file error: ${e.message}")
            return
        }
        recorder?.startRecording()
        isRecording = true

        recordingThread = Thread {
            val buffer = ByteArray(bufferSize)
            try {
                while (isRecording) {
                    val read = recorder!!.read(buffer, 0, buffer.size)
                    if (read > 0) {
                        pcmOutputStream?.write(buffer, 0, read)
                    }
                }
                pcmOutputStream?.close()
            } catch (e: Exception) {
                Log.e("AudioCaptureService", "Error: ${e.message}")
            }
        }

        recordingThread.start()
    }

    override fun onDestroy() {
        isRecording = false
        recorder?.stop()
        recorder?.release()
        recorder = null
        // Convert PCM sang WAV nếu có file PCM
        if (pcmFilePath != null && wavFilePath != null) {
            convertPcmToWav(pcmFilePath!!, wavFilePath!!)
            // Lưu file WAV vào MediaStore
            saveWavToMediaStore(wavFilePath!!)
            // Xóa file PCM nếu muốn
            // File(pcmFilePath!!).delete()
        }
        super.onDestroy()
    }

    override fun onBind(intent: Intent?): IBinder? = null

    private fun convertPcmToWav(pcmPath: String, wavPath: String, sampleRate: Int = 44100, channels: Int = 2, bitsPerSample: Int = 16) {
        try {
            val pcmFile = File(pcmPath)
            val wavFile = File(wavPath)
            val pcmSize = pcmFile.length().toInt()
            val inputStream = FileInputStream(pcmFile)
            val outputStream = FileOutputStream(wavFile)

            // WAV header
            val header = createWavHeader(pcmSize, sampleRate, channels, bitsPerSample)
            outputStream.write(header)

            // PCM data
            val buffer = ByteArray(4096)
            var read = inputStream.read(buffer)
            while (read > 0) {
                outputStream.write(buffer, 0, read)
                read = inputStream.read(buffer)
            }
            inputStream.close()
            outputStream.close()
        } catch (e: Exception) {
            Log.e("AudioCaptureService", "PCM to WAV error: ${e.message}")
        }
    }

    private fun createWavHeader(pcmSize: Int, sampleRate: Int, channels: Int, bitsPerSample: Int): ByteArray {
        val totalDataLen = pcmSize + 36
        val byteRate = sampleRate * channels * bitsPerSample / 8
        val header = ByteArray(44)

        // ChunkID "RIFF"
        header[0] = 'R'.toByte()
        header[1] = 'I'.toByte()
        header[2] = 'F'.toByte()
        header[3] = 'F'.toByte()
        // ChunkSize
        writeInt(header, 4, totalDataLen)
        // Format "WAVE"
        header[8] = 'W'.toByte()
        header[9] = 'A'.toByte()
        header[10] = 'V'.toByte()
        header[11] = 'E'.toByte()
        // Subchunk1ID "fmt "
        header[12] = 'f'.toByte()
        header[13] = 'm'.toByte()
        header[14] = 't'.toByte()
        header[15] = ' '.toByte()
        // Subchunk1Size (16 for PCM)
        writeInt(header, 16, 16)
        // AudioFormat (1 for PCM)
        header[20] = 1
        header[21] = 0
        // NumChannels
        header[22] = channels.toByte()
        header[23] = 0
        // SampleRate
        writeInt(header, 24, sampleRate)
        // ByteRate
        writeInt(header, 28, byteRate)
        // BlockAlign
        header[32] = (channels * bitsPerSample / 8).toByte()
        header[33] = 0
        // BitsPerSample
        header[34] = bitsPerSample.toByte()
        header[35] = 0
        // Subchunk2ID "data"
        header[36] = 'd'.toByte()
        header[37] = 'a'.toByte()
        header[38] = 't'.toByte()
        header[39] = 'a'.toByte()
        // Subchunk2Size
        writeInt(header, 40, pcmSize)
        return header
    }

    private fun writeInt(header: ByteArray, offset: Int, value: Int) {
        header[offset] = (value and 0xff).toByte()
        header[offset + 1] = ((value shr 8) and 0xff).toByte()
        header[offset + 2] = ((value shr 16) and 0xff).toByte()
        header[offset + 3] = ((value shr 24) and 0xff).toByte()
    }

    private fun saveWavToMediaStore(wavPath: String) {
        try {
            val file = File(wavPath)
            val resolver = applicationContext.contentResolver
            val contentValues = android.content.ContentValues().apply {
                put(android.provider.MediaStore.Audio.Media.DISPLAY_NAME, file.name)
                put(android.provider.MediaStore.Audio.Media.MIME_TYPE, "audio/wav")
                put(android.provider.MediaStore.Audio.Media.RELATIVE_PATH, "Music/DrumPad")
                put(android.provider.MediaStore.Audio.Media.IS_MUSIC, 1)
            }
            val audioCollection = if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.Q) {
                android.provider.MediaStore.Audio.Media.getContentUri(android.provider.MediaStore.VOLUME_EXTERNAL_PRIMARY)
            } else {
                android.provider.MediaStore.Audio.Media.EXTERNAL_CONTENT_URI
            }
            val uri = resolver.insert(audioCollection, contentValues)
            if (uri != null) {
                val outStream = resolver.openOutputStream(uri)
                val inStream = FileInputStream(file)
                val buffer = ByteArray(4096)
                var read = inStream.read(buffer)
                while (read > 0) {
                    outStream?.write(buffer, 0, read)
                    read = inStream.read(buffer)
                }
                inStream.close()
                outStream?.close()
            }
        } catch (e: Exception) {
            Log.e("AudioCaptureService", "Save wav to MediaStore error: ${e.message}")
        }
    }
}
