
import 'package:drumpad_flutter/core/constants/mock_up_data.dart';
import 'package:drumpad_flutter/src/mvvm/models/lesson_model.dart';
import 'package:drumpad_flutter/src/service/song_collection_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
class DrumLearnProvider extends ChangeNotifier {
  List<SongCollection> data = dataSongCollections;
  /// path to get audio file
  String pathDir = '';

  List<String> _listIdSongResume = [];
  // List<String> get listIdSongResume => _listIdSongResume;

  List<SongCollection> _listSongResume = [];
  List<SongCollection> get listSongResume => _listSongResume;

  int _perfectPoint = 0;
  bool _isCombo = false;
  bool _isRecording = false;
  int _increaseScoreByCombo = 0;
  int _beatRunnerSongComplete = 0;
  int _learnSongComplete = 0;
  int _totalPoint = 0;
  double _totalStar = 0;
  double _beatRunnerStar = 0;
  bool _isChooseSong = false;


  int get perfectPoint => _perfectPoint;
  bool get isCombo => _isCombo;
  bool get isChooseSong => _isChooseSong;
  bool get isRecording => _isRecording;
  int get increaseScoreByCombo => _increaseScoreByCombo;
  int get totalPoint => _totalPoint;
  int get beatRunnerSongComplete => _beatRunnerSongComplete;
  int get learnSongComplete => _learnSongComplete;
  double get totalStar => _totalStar;
  double get beatRunnerStar => _beatRunnerStar;

  DrumLearnProvider(){
    fetchListResume();
    getBeatRunnerSongComplete();
    getLearnSongComplete();
    getTotalStars();
    // getBeatRunnerStars();
    getBeatRunnerStar();
    _setPathDir();
  }

  Future<void> _setPathDir() async {
    var dir = await getApplicationDocumentsDirectory();
    await dir.create(recursive: true);
    pathDir = '${dir.path}/data_packs';
    notifyListeners();
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
  Future<SongCollection?> getSong(String id) async {
    return await SongCollectionService.getSongById(id);
  }

  Future<List<SongCollection>> getRandomSongs() async {
    List<SongCollection> shuffledList = List.from(dataSongCollections)..shuffle();
    return shuffledList.take(5).toList();
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
        if(song != null) listSong.add(song);
      } catch (e) {
        print('Error fetching song with id $id: $e');
      }
    }
    _listSongResume =  listSong;
    notifyListeners();
  }

  ///runner
  Future<void> getBeatRunnerSongComplete() async {
    final prefs = await SharedPreferences.getInstance();
    int? savedValue = prefs.getInt('runnerComplete');
    print('get count $savedValue');
    _beatRunnerSongComplete = savedValue ?? 0;
    notifyListeners();
  }


  Future<void> addBeatRunnerSongComplete(String id) async {
    final prefs = await SharedPreferences.getInstance();

    List<String> completedIds = prefs.getStringList('runnerCompleteIds') ?? [];

    if (completedIds.contains(id)) return;

    completedIds.add(id);
    await prefs.setStringList('runnerCompleteIds', completedIds);

    _beatRunnerSongComplete++;
    await prefs.setInt('runnerComplete', _beatRunnerSongComplete);
    print('add count $_beatRunnerSongComplete');
    notifyListeners();
  }
  ///learn
  Future<void> getLearnSongComplete() async {
    final prefs = await SharedPreferences.getInstance();
    int? savedValue = prefs.getInt('learnComplete');
    print('learn song count $savedValue');
    _learnSongComplete = savedValue ?? 0;
    notifyListeners();
  }

  Future<void> addLearnSongComplete(String id) async {
    print('lele');
    final prefs = await SharedPreferences.getInstance();

    List<String> completedIds = prefs.getStringList('learnSongCompleteIds') ?? [];

    if (completedIds.contains(id)) return;

    completedIds.add(id);
    await prefs.setStringList('learnSongCompleteIds', completedIds);

    _learnSongComplete++;
    await prefs.setInt('learnSongComplete', _learnSongComplete);
    print('add count $_learnSongComplete');
    notifyListeners();
  }
  /// BeatRunnerStar
  Future<void> getBeatRunnerStar() async {
    final prefs = await SharedPreferences.getInstance();
    double? savedValue = prefs.getDouble('beatRunnerStar');
    _beatRunnerStar = savedValue ?? 0;
    notifyListeners();
  }

  Future<void> addBeatRunnerStar(String id, double star) async {
    final prefs = await SharedPreferences.getInstance();

    List<String> completedIds = prefs.getStringList('beatRunnerStarIds') ?? [];

    if (completedIds.contains(id)) return;

    completedIds.add(id);
    await prefs.setStringList('beatRunnerStarIds', completedIds);

    _beatRunnerStar += star;
    await prefs.setDouble('beatRunnerStar', _beatRunnerStar);
    print('add count $_beatRunnerStar');
    notifyListeners();
  }

  Future<void> getTotalStars() async{
     _totalStar = await SongCollectionService.getTotalStarsOfAllSongCollections();
    print(totalStar);
    notifyListeners();
  }
  // Future<void> getBeatRunnerStars() async{
  //   _beatRunnerStar = await SongCollectionService.getLessonStarsByIndexFromAllSongCollections(0);
  //   print(_beatRunnerStar);
  //   notifyListeners();
  // }

  void updateChooseSong(){
    _isChooseSong = !_isChooseSong;
    notifyListeners();
  }
}
