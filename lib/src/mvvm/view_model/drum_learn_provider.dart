import 'dart:convert';

import 'package:drumpad_flutter/core/constants/mock_up_data.dart';
import 'package:drumpad_flutter/core/res/drawer/image.dart';
import 'package:drumpad_flutter/src/mvvm/models/lesson_model.dart';
import 'package:drumpad_flutter/src/service/song_collection_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
class DrumLearnProvider extends ChangeNotifier {
  List<SongCollection> data = dataSongCollections;

  List<String> _listIdSongResume = [];
  // List<String> get listIdSongResume => _listIdSongResume;

  List<SongCollection> _listSongResume = [];
  List<SongCollection> get listSongResume => _listSongResume;

  int _perfectPoint = 0;
  bool _isCombo = false;
  bool _isRecording = false;
  int _increaseScoreByCombo = 0;
  int _totalPoint = 0;

  int get perfectPoint => _perfectPoint;
  bool get isCombo => _isCombo;
  bool get isRecording => _isRecording;
  int get increaseScoreByCombo => _increaseScoreByCombo;
  int get totalPoint => _totalPoint;

  DrumLearnProvider(){
    fetchListResume();
  }

  void increasePerfectPoint() {
    _perfectPoint ++;
    if (_perfectPoint >= 3) {
      _increaseScoreByCombo = 50 * _perfectPoint;
      _isCombo = true;
      _totalPoint = _increaseScoreByCombo;
      notifyListeners();
      print(_totalPoint);

      Future.delayed(const Duration(milliseconds: 500), () {
        _increaseScoreByCombo = 0;
        notifyListeners();
      });
      Future.delayed(const Duration(milliseconds: 2000), () {
        _isCombo = false;
        notifyListeners();
      });
    }
    notifyListeners();
    print('_perfectPoint $_perfectPoint');
  }

  void resetPerfectPoint() {
    print('resetALLllll');
    _perfectPoint = 0;
    _increaseScoreByCombo = 0;
    _totalPoint = 0;
    notifyListeners();
  }
  void resetIsCombo(){
    _isCombo = false;
    notifyListeners();
  }
  void updateRecording(){
    _isRecording = !_isRecording;
    notifyListeners();
  }

  /// Function for drum learn song
  Future<SongCollection> getSong(String id) async {
    return await SongCollectionService.getSongById(id) ?? await getSongFromServer(id);
  }

  Future<void> updateSong(String id, SongCollection songCollection) async {
    await SongCollectionService.updateSong(id, songCollection);
  }

  Future<SongCollection> getSongFromServer(String id) async {
    /// call api get song by id
    return dataSongCollections.firstWhere((element) => element.id == id, orElse: () => dataSongCollections.last,);
  }

  Future<void> fetchListResume() async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList('listResume') ?? [];
    _listIdSongResume = list;
    await _getListResumeSongById();
    notifyListeners();
  }

  Future<void> addToResume(String id) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> listResume = prefs.getStringList('listResume') ?? [];

    // check id exist
    if (listResume.contains(id)) {
      // if exist
      listResume.remove(id);
    }

    listResume.insert(0, id);

    // limit 5 item
    if (listResume.length > 5) {
      listResume = listResume.sublist(0, 5);
    }
    await prefs.setStringList('listResume', listResume);
    _listIdSongResume = listResume;
    _getListResumeSongById();
    notifyListeners();
  }

  Future<void> _getListResumeSongById() async {
    final List<SongCollection> listSong = [];

    for (final id in _listIdSongResume) {
      try {
        final song = await getSong(id);
        listSong.add(song);
      } catch (e) {
        print('Error fetching song with id $id: $e');
      }
    }

    _listSongResume =  listSong;
    notifyListeners();
  }
}
