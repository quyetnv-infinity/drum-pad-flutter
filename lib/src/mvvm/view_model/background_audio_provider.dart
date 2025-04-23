import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:just_audio/just_audio.dart';

class BackgroundAudioProvider extends ChangeNotifier {
  AudioPlayer? _audioPlayer = AudioPlayer();
  final List<String> _musicList = [
    'assets/audio/hypnus.mp3',
    'assets/audio/money.mp3',
    'assets/audio/hypnus_a.mp3',
    'assets/audio/mortals.mp3',
    'assets/audio/warriors.mp3',
  ];
  List<String> _remainingTracks = [];

  bool _isPlaying = false;
  bool _homePlaying = false;

  bool get isPlaying => _isPlaying;
  bool get homePlaying => _homePlaying;

  BackgroundAudioProvider() {
    _init();
  }

  Future<void> _init() async {
    _audioPlayer!.setLoopMode(LoopMode.off);

    _audioPlayer!.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed) {
        _playNextRandom();
      }
    });

    await _playNextRandom();
  }

  Future<void> _playNextRandom() async {
    try {
      if (_remainingTracks.isEmpty) {
        _remainingTracks = List.from(_musicList);
      }

      final random = Random();
      final index = random.nextInt(_remainingTracks.length);
      final nextTrack = _remainingTracks.removeAt(index);

      await _audioPlayer!.setAsset(nextTrack);
      await _audioPlayer!.play();

      _isPlaying = true;
      notifyListeners();
    } catch (e) {
      print('Error playing audio: $e');
    }
  }
  Future<void> play() async {
    if (!_isPlaying) {
      _isPlaying = true;
      notifyListeners();
      await _audioPlayer!.play();
    }
  }

  Future<void> pause() async {
    if (_isPlaying) {
      _isPlaying = false;
      notifyListeners();
      await _audioPlayer!.pause();}
  }

  Future<void> toggle() async {
    if (_isPlaying) {
      await pause();
    } else {
      await play();
    }
    notifyListeners();
  }
  void stopAndResetAudio() {
    _audioPlayer!.stop();
    _audioPlayer!.dispose();
    _audioPlayer = AudioPlayer();
    _isPlaying = false;
    notifyListeners();
  }

  String playingSong() {
    final currentSource = _audioPlayer?.audioSource;
    if (currentSource is ProgressiveAudioSource) {
      final uri = currentSource.uri.toString();
      final parts = uri.split('/');
      final fileName = parts.isNotEmpty ? parts.last.replaceAll('.mp3', '') : 'Unknown';
      switch (fileName) {
        case 'hypnus':
          return 'Hypnus - Cee Qui Ell';
        case 'money':
          return 'Money - Cee qui Ell';
        case 'hypnus_a':
          return 'Hypnus2 - Cee qui Ell';
        case 'mortals':
          return 'Mortals - Warriyo';
        case 'warriors':
          return 'Warriors - Cee qui Ell';
        default:
          return fileName;
      }
    }
    return 'Unknown';
  }


  @override
  void dispose() {
    if (_isPlaying) {
      _audioPlayer!.stop();
    }
    _audioPlayer?.dispose();
    super.dispose();
  }
}
