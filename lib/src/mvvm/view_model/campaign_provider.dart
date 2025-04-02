import 'package:drumpad_flutter/core/constants/mock_up_data.dart';
import 'package:drumpad_flutter/src/mvvm/models/lesson_model.dart';
import 'package:drumpad_flutter/src/service/song_collection_service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CampaignProvider with ChangeNotifier {
  int _easyUnlocked = 0;
  int _mediumUnlocked = 0;
  int _hardUnlocked = 0;
  int _demonicUnlocked = 0;

  int get easyUnlocked => _easyUnlocked;
  int get mediumUnlocked => _mediumUnlocked;
  int get hardUnlocked => _hardUnlocked;
  int get demonicUnlocked => _demonicUnlocked;

  List<SongCollection> _easyCampaign = [];
  List<SongCollection> _mediumCampaign = [];
  List<SongCollection> _hardCampaign = [];
  List<SongCollection> _demonicCampaign = [];

  List<SongCollection> get easyCampaign => _easyCampaign;
  List<SongCollection> get mediumCampaign => _mediumCampaign;
  List<SongCollection> get hardCampaign => _hardCampaign;
  List<SongCollection> get demonicCampaign => _demonicCampaign;

  CampaignProvider(){
    initUnlocked();
  }

  Future<void> initUnlocked() async {
    final prefs = await SharedPreferences.getInstance();
    _easyUnlocked = prefs.getInt('easyUnlocked') ?? 0;
    _mediumUnlocked = prefs.getInt('mediumUnlocked') ?? 0;
    _hardUnlocked = prefs.getInt('hardUnlocked') ?? 0;
    _demonicUnlocked = prefs.getInt('demonicUnlocked') ?? 0;
  }

  Future<void> fetchCampaignSong({bool isEasy = false, bool isMedium = false, bool isHard = false, bool isDemonic = false}) async {
    if(isEasy) _easyCampaign = mergeLists(dataSongCollections.where((song) => song.difficulty == DifficultyMode.easy,).toList(), await getListSongByDifficulty(DifficultyMode.easy));
    if(isMedium) _mediumCampaign = mergeLists(dataSongCollections.where((song) => song.difficulty == DifficultyMode.medium,).toList(), await getListSongByDifficulty(DifficultyMode.medium));
    if(isHard) _hardCampaign = mergeLists(dataSongCollections.where((song) => song.difficulty == DifficultyMode.hard,).toList(), await getListSongByDifficulty(DifficultyMode.hard));
    if(isEasy) _demonicCampaign = mergeLists(dataSongCollections.where((song) => song.difficulty == DifficultyMode.demonic,).toList(), await getListSongByDifficulty(DifficultyMode.demonic));
    notifyListeners();
  }

  Future<List<SongCollection>> getListSongByDifficulty(String difficulty) async {
    return await SongCollectionService.getListSongByDifficultyMode(difficulty);
  }

  List<SongCollection> mergeLists(List<SongCollection> listFromServer, List<SongCollection> listFromDB) {
    Map<String, SongCollection> mapB = {for (var item in listFromDB) item.id: item};

    return listFromServer.map((item) => mapB.containsKey(item.id) ? mapB[item.id]! : item).toList();
  }

  Future<void> setUnlocked({required String difficult, required int value}) async {
    final isEasy = difficult == DifficultyMode.easy;
    final isMedium = difficult == DifficultyMode.medium;
    final isHard = difficult == DifficultyMode.hard;
    final isDemonic = difficult == DifficultyMode.demonic;
    isEasy ? _easyUnlocked = value : (isMedium ? _mediumUnlocked = value : (isHard ? _hardUnlocked = value : _demonicUnlocked = value));
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('${isEasy? 'easy' : (isMedium ? 'medium' : (isHard ? 'hard' : 'demonic'))}Unlocked', value);
  }

}