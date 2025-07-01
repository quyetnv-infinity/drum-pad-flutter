import 'package:and_drum_pad_flutter/data/service/media_recorder_service.dart';
import 'package:flutter/foundation.dart';

class RecordingProvider extends ChangeNotifier {
  bool _isRecording = false;
  bool _isPaused = false;
  String? _currentRecordingPath;
  List<Map<String, dynamic>> _recordedFiles = [];
  String? _lastRecordedFilePath;
  bool _isLoading = false;

  // Getters
  bool get isRecording => _isRecording;
  bool get isPaused => _isPaused;
  String? get currentRecordingPath => _currentRecordingPath;
  List<Map<String, dynamic>> get recordedFiles => _recordedFiles;
  String? get lastRecordedFilePath => _lastRecordedFilePath;
  bool get isLoading => _isLoading;

  // Constructor
  RecordingProvider() {
    _loadRecordedFiles();
    // _resetRecordingStateOnInit(); // Tạm thời comment để test
  }

  // Load danh sách file đã ghi
  Future<void> _loadRecordedFiles() async {
    try {
      _isLoading = true;
      notifyListeners();

      final files = await MediaRecorderService.getRecordedFiles();
      _recordedFiles = files;

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      print('Error loading recorded files: $e');
    }
  }

  // Bắt đầu ghi âm
  Future<bool> startRecording() async {
    try {
      _isLoading = true;
      notifyListeners();

      final result = await MediaRecorderService.startRecording();

      if (result != null) {
        _isRecording = true;
        _isPaused = false;
        _currentRecordingPath = result['filePath'];
        _lastRecordedFilePath = null; // Reset last recorded file

        _isLoading = false;
        notifyListeners();

        print('Recording started: ${result['filePath']}');
        return true;
      } else {
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      print('Error starting recording: $e');
      return false;
    }
  }

  // Dừng ghi âm
  Future<Map<String, dynamic>?> stopRecording() async {
    try {
      if (!_isRecording) {
        print('No recording in progress');
        return null;
      }

      _isLoading = true;
      notifyListeners();

      final result = await MediaRecorderService.stopRecording();

      if (result != null) {
        _isRecording = false;
        _isPaused = false;
        _lastRecordedFilePath = result['filePath'];
        _currentRecordingPath = null;

        // Reload danh sách file
        await _loadRecordedFiles();

        _isLoading = false;
        notifyListeners();

        print('Recording stopped: ${result['filePath']}');
        return result;
      } else {
        _isLoading = false;
        notifyListeners();
        return null;
      }
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      print('Error stopping recording: $e');
      return null;
    }
  }

  // Refresh danh sách file
  Future<void> refreshFiles() async {
    await _loadRecordedFiles();
  }

  // Clear last recorded file path
  void clearLastRecordedFile() {
    _lastRecordedFilePath = null;
    notifyListeners();
  }

  // Get file info by path
  Map<String, dynamic>? getFileInfo(String filePath) {
    try {
      return _recordedFiles.firstWhere((file) => file['path'] == filePath);
    } catch (e) {
      return null;
    }
  }

  // Check if file exists
  bool hasFile(String filePath) {
    return _recordedFiles.any((file) => file['path'] == filePath);
  }

  // Get total size of all recorded files
  double getTotalSizeInMB() {
    double totalSize = 0;
    for (var file in _recordedFiles) {
      totalSize += double.tryParse(file['sizeInMB'] ?? '0') ?? 0;
    }
    return totalSize;
  }

  // Get recording duration (if available)
  Duration? getRecordingDuration() {
    // This would need to be implemented based on your needs
    // You could track start time and calculate duration
    return null;
  }

  // Reset recording state on init
  Future<void> _resetRecordingStateOnInit() async {
    try {
      await MediaRecorderService.resetRecordingState();
      // Reset local state as well
      _isRecording = false;
      _isPaused = false;
      _currentRecordingPath = null;
      notifyListeners();
    } catch (e) {
      print('Error resetting recording state on init: $e');
    }
  }
}