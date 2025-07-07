import 'package:flutter_soloud/flutter_soloud.dart';

class SoLoudService {
  static SoLoudService? _instance;
  static SoLoud? _soloud;
  static bool _isInitialized = false;

  SoLoudService._();

  static SoLoudService get instance {
    _instance ??= SoLoudService._();
    return _instance!;
  }

  /// Get the SoLoud instance
  SoLoud get soloud {
    if (!_isInitialized) {
      throw StateError('SoLoud has not been initialized. Call initialize() first.');
    }
    return _soloud!;
  }

  /// Check if SoLoud is initialized
  bool get isInitialized => _isInitialized;

  /// Initialize SoLoud
  Future<void> initialize() async {
    if (_isInitialized) {
      print('SoLoud is already initialized');
      return;
    }

    print('Initializing SoLoud...');
    try {
      _soloud = SoLoud.instance;
      await _soloud!.init();
      _isInitialized = true;
      print('SoLoud initialized successfully');
    } catch (e) {
      print('Error initializing SoLoud: $e');
      rethrow;
    }
  }

  /// Dispose SoLoud resources
  Future<void> dispose() async {
    if (!_isInitialized) {
      print('SoLoud is not initialized');
      return;
    }

    try {
      _soloud!.deinit();
      _isInitialized = false;
      _soloud = null;
      print('SoLoud disposed successfully');
    } catch (e) {
      print('Error disposing SoLoud: $e');
    }
  }

  /// Load audio file from path
  Future<AudioSource> loadFile(String path) async {
    if (!_isInitialized) {
      await initialize();
    }
    return await _soloud!.loadFile(path);
  }

  /// Load audio asset
  Future<AudioSource> loadAsset(String assetPath) async {
    if (!_isInitialized) {
      await initialize();
    }
    return await _soloud!.loadAsset(assetPath);
  }

  /// Play audio source
  Future<SoundHandle> play(AudioSource source) async {
    if (!_isInitialized) {
      await initialize();
    }
    return await _soloud!.play(source);
  }

  /// Stop sound handle
  void stop(SoundHandle handle) {
    if (!_isInitialized) return;
    _soloud!.stop(handle);
  }

  /// Dispose audio source
  void disposeSource(AudioSource source) {
    if (!_isInitialized) return;
    _soloud!.disposeSource(source);
  }
} 