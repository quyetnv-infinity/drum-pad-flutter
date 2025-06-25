import 'package:and_drum_pad_flutter/data/model/campaign_model.dart';
import 'package:and_drum_pad_flutter/data/model/lesson_model.dart';
import 'package:and_drum_pad_flutter/data/service/song_collection_service.dart';
import 'package:and_drum_pad_flutter/view_model/category_provider.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CampaignProvider with ChangeNotifier {
  CategoryProvider _categoryProvider;
  List<CampaignModel> _campaigns = [
    CampaignModel(
      difficulty: DifficultyMode.easy,
      data: [],
      unlocked: 0,
    ),
    CampaignModel(
      difficulty: DifficultyMode.medium,
      data: [],
      unlocked: 0,
    ),
    CampaignModel(
      difficulty: DifficultyMode.hard,
      data: [],
      unlocked: 0,
    ),
    CampaignModel(
      difficulty: DifficultyMode.demonic,
      data: [],
      unlocked: 0,
    ),
  ];

  List<CampaignModel> get campaigns => _campaigns;

  int get easyUnlocked => _campaigns[0].unlocked;

  int get mediumUnlocked => _campaigns[1].unlocked;

  int get hardUnlocked => _campaigns[2].unlocked;

  int get demonicUnlocked => _campaigns[3].unlocked;

  int _currentLessonCampaign = 0;

  int get currentLessonCampaign => _currentLessonCampaign;

  int _currentSongCampaign = 0;

  int get currentSongCampaign => _currentSongCampaign;

  List<SongCollection> currentCampaign = [];

  // Getter methods for backward compatibility
  List<SongCollection> get easyCampaign => _campaigns[0].data;

  List<SongCollection> get mediumCampaign => _campaigns[1].data;

  List<SongCollection> get hardCampaign => _campaigns[2].data;

  List<SongCollection> get demonicCampaign => _campaigns[3].data;

  CampaignProvider(this._categoryProvider) {
    initUnlocked();
  }

  void updateDependencies(CategoryProvider categoryProvider) {
    _categoryProvider = categoryProvider;
    notifyListeners();
  }

  Future<void> initUnlocked() async {
    final prefs = await SharedPreferences.getInstance();
    _campaigns[0].unlocked = prefs.getInt('easyUnlocked') ?? 0;
    _campaigns[1].unlocked = prefs.getInt('mediumUnlocked') ?? 0;
    _campaigns[2].unlocked = prefs.getInt('hardUnlocked') ?? 0;
    _campaigns[3].unlocked = prefs.getInt('demonicUnlocked') ?? 0;
    notifyListeners();
  }

  void setCurrentLessonCampaign(int value) {
    _currentLessonCampaign = value;
    notifyListeners();
  }

  void setCurrentSongCampaign(int value) {
    _currentSongCampaign = value;
    print('campaign index at $value');
    notifyListeners();
  }

  void setCurrentCampaign({
    bool isEasy = false,
    bool isMedium = false,
    bool isHard = false,
    bool isDemonic = false,
  }) {
    if (isEasy) currentCampaign = _campaigns[0].data;
    if (isMedium) currentCampaign = _campaigns[1].data;
    if (isHard) currentCampaign = _campaigns[2].data;
    if (isDemonic) currentCampaign = _campaigns[3].data;
    notifyListeners();
  }

  Future<void> fetchCampaignSong(
      {bool isEasy = false,
      bool isMedium = false,
      bool isHard = false,
      bool isDemonic = false}) async {
    if (isEasy) {
      _campaigns[0].data = mergeLists(
        await _getSongsByDifficulty(DifficultyMode.easy),
        await _getListSongByDifficulty(DifficultyMode.easy),
      );
    }
    if (isMedium) {
      _campaigns[1].data = mergeLists(
        await _getSongsByDifficulty(DifficultyMode.medium),
        await _getListSongByDifficulty(DifficultyMode.medium),
      );
    }
    if (isHard) {
      _campaigns[2].data = mergeLists(
        await _getSongsByDifficulty(DifficultyMode.hard),
        await _getListSongByDifficulty(DifficultyMode.hard),
      );
    }
    if (isDemonic) {
      _campaigns[3].data = mergeLists(
        await _getSongsByDifficulty(DifficultyMode.demonic),
        await _getListSongByDifficulty(DifficultyMode.demonic),
      );
    }
    notifyListeners();
  }

  // Phương thức mới để fetch campaign theo difficulty
  Future<void> fetchCampaignByDifficulty(String difficulty) async {
    final campaignIndex = _getDifficultyIndex(difficulty);
    if (campaignIndex == -1) return;

    _campaigns[campaignIndex].data = mergeLists(
      await _getSongsByDifficulty(difficulty),
      await _getListSongByDifficulty(difficulty),
    );
    notifyListeners();
  }

  // Phương thức helper để lấy index từ difficulty
  int _getDifficultyIndex(String difficulty) {
    switch (difficulty) {
      case DifficultyMode.easy:
        return 0;
      case DifficultyMode.medium:
        return 1;
      case DifficultyMode.hard:
        return 2;
      case DifficultyMode.demonic:
        return 3;
      default:
        return -1;
    }
  }

  // Phương thức để lấy campaign theo difficulty
  List<SongCollection> getCampaignByDifficulty(String difficulty) {
    final index = _getDifficultyIndex(difficulty);
    return index != -1 ? _campaigns[index].data : [];
  }

  Future<List<SongCollection>> _getSongsByDifficulty(String difficulty) async {
    final categories = _categoryProvider.categories;
    if (categories.isEmpty) await _categoryProvider.fetchCategories();
    List<SongCollection> result = [];
    for (var category in categories) {
      if (category.items == null || category.items!.isEmpty) continue;
      final songs = category.items
          ?.where(
            (song) => song.difficulty == difficulty,
          )
          .toList();
      if (songs != null && songs.isNotEmpty) result.addAll(songs);
    }
    return result;
  }

  /// get list in database
  Future<List<SongCollection>> _getListSongByDifficulty(
      String difficulty) async {
    return await SongCollectionService.getListSongByDifficultyMode(difficulty);
  }

  /// merge list from server and database
  List<SongCollection> mergeLists(
      List<SongCollection> listFromServer, List<SongCollection> listFromDB) {
    Map<String, SongCollection> mapB = {
      for (var item in listFromDB) item.id: item
    };

    return listFromServer
        .map((item) => mapB.containsKey(item.id) ? mapB[item.id]! : item)
        .toList();
  }

  /// set indexUnlocked of difficulty list at campaign
  Future<void> setUnlocked(
      {required String difficult, required int value}) async {
    final campaignIndex = _getDifficultyIndex(difficult);
    if (campaignIndex == -1) return;

    _campaigns[campaignIndex].unlocked = value;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    final prefKey = '${_getDifficultyName(difficult)}Unlocked';
    await prefs.setInt(prefKey, value);
  }

  // Helper method để lấy tên difficulty cho SharedPreferences
  String _getDifficultyName(String difficulty) {
    switch (difficulty) {
      case DifficultyMode.easy:
        return 'easy';
      case DifficultyMode.medium:
        return 'medium';
      case DifficultyMode.hard:
        return 'hard';
      case DifficultyMode.demonic:
        return 'demonic';
      default:
        return '';
    }
  }

  Future<SongCollection?> getSong(String id) async {
    return await SongCollectionService.getSongById(id);
  }

  Future<void> updateSong(String id, SongCollection songCollection) async {
    await SongCollectionService.updateSong(id, songCollection);
  }
}
