import 'package:drumpad_flutter/core/constants/mock_up_data.dart';
import 'package:drumpad_flutter/src/mvvm/models/lesson_model.dart';
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

  void fetchCampaignSong({bool isEasy = false, bool isMedium = false, bool isHard = false, bool isDemonic = false}){
    if(isEasy) _easyCampaign = dataSongCollections.where((song) => song.difficulty == DifficultyMode.easy,).toList();
    if(isMedium) _mediumCampaign = dataSongCollections.where((song) => song.difficulty == DifficultyMode.medium,).toList();
    if(isHard) _hardCampaign = dataSongCollections.where((song) => song.difficulty == DifficultyMode.hard,).toList();
    if(isEasy) _demonicCampaign = dataSongCollections.where((song) => song.difficulty == DifficultyMode.demonic,).toList();
    notifyListeners();
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