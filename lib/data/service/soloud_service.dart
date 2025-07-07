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

  /// Fade out sound handle
  Future<void> fadeOut(SoundHandle handle, {Duration duration = const Duration(milliseconds: 200)}) async {
    if (!_isInitialized) return;
    
    try {
      // Get current volume
      final currentVolume = _soloud!.getVolume(handle);
      final steps = (duration.inMilliseconds / 10).round(); // 10ms per step
      final volumeStep = currentVolume / steps;
      
      // Gradually reduce volume
      for (int i = 0; i < steps; i++) {
        final newVolume = currentVolume - (volumeStep * i);
        _soloud!.setVolume(handle, newVolume);
        await Future.delayed(Duration(milliseconds: 10));
      }
      
      // Stop the sound
      _soloud!.stop(handle);
    } catch (e) {
      print('Error during fade out: $e');
      // Fallback to immediate stop
      _soloud!.stop(handle);
    }
  }

  /// Play audio source with fade in
  Future<SoundHandle> playWithFadeIn(AudioSource source, {Duration duration = const Duration(milliseconds: 200)}) async {
    if (!_isInitialized) {
      await initialize();
    }
    
    final handle = await _soloud!.play(source);
    
    // Start with volume 0
    _soloud!.setVolume(handle, 0.0);
    
    // Fade in
    final steps = (duration.inMilliseconds / 10).round(); // 10ms per step
    final volumeStep = 1.0 / steps;
    
    for (int i = 0; i < steps; i++) {
      final newVolume = volumeStep * (i + 1);
      _soloud!.setVolume(handle, newVolume);
      await Future.delayed(Duration(milliseconds: 10));
    }
    
    // Ensure final volume is 1.0
    _soloud!.setVolume(handle, 1.0);
    
    return handle;
  }

  /// Dispose audio source
  void disposeSource(AudioSource source) {
    if (!_isInitialized) return;
    _soloud!.disposeSource(source);
  }
} 