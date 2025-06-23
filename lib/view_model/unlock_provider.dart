import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UnlockedSongsProvider with ChangeNotifier {
  static const String _unlockedSongsKey = 'unlocked_song_ids';
  List<String> _unlockedSongIds = [];

  List<String> get unlockedSongIds => _unlockedSongIds;

  UnlockedSongsProvider() {
    _loadUnlockedSongs();
  }

  Future<void> _loadUnlockedSongs() async {
    final prefs = await SharedPreferences.getInstance();
    _unlockedSongIds = prefs.getStringList(_unlockedSongsKey) ?? [];
    notifyListeners();
  }

  Future<void> unlockSong(String songId) async {
    if (!_unlockedSongIds.contains(songId)) {
      _unlockedSongIds.add(songId);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList(_unlockedSongsKey, _unlockedSongIds);
      notifyListeners();
    }
  }

  bool isSongUnlocked(String songId) {
    return _unlockedSongIds.contains(songId);
  }
}
