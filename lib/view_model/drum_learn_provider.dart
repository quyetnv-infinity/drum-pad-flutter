import 'package:and_drum_pad_flutter/data/model/lesson_model.dart';
import 'package:and_drum_pad_flutter/data/service/api_service/song_service.dart';
import 'package:and_drum_pad_flutter/data/service/song_collection_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DrumLearnProvider extends ChangeNotifier {
  final SongService _songService;
  /// path to get audio file
  String pathDir = '';

  List<String> _listIdSongResume = [];
  // List<String> get listIdSongResume => _listIdSongResume;

  List<SongCollection> _listSongResume = [];
  List<SongCollection> get listSongResume => _listSongResume;

  List<SongCollection> _listRecommend = [];
  List<SongCollection> get listRecommend => _listRecommend;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

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

  DrumLearnProvider(this._songService){
    fetchListResume();
    getBeatRunnerSongComplete();
    getLearnSongComplete();
    getTotalStars();
    // getBeatRunnerStars();
    getBeatRunnerStar();
    _setPathDir();
    getRecommend();
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

  Future<void> getRecommend() async {
    if(_listRecommend.isNotEmpty) return;
      _isLoading = true;
    try {
      final res = await _songService.fetchRecommend();
      _listRecommend = res.data ?? [];
      print("recommend: $_listRecommend");
    } catch (e, stackTrace) {

      print('Error fetching trending: $e $stackTrace');
    }finally{
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateSong(String id, SongCollection songCollection) async {
    await SongCollectionService.updateSong(id, songCollection);
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
    await _getListResumeSongById();
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
    // print('get list resume ${listSong.first.name}');
    _listSongResume =  listSong;
    notifyListeners();
  }
  //
  // Future<List<SongCollection>> getSongsByCategory(String category) async {
  //   return mergeLists(data, await SongCollectionService.getAll());
  // }
  //
  // List<SongCollection> mergeLists(List<SongCollection> listFromServer, List<SongCollection> listFromDB) {
  //   Map<String, SongCollection> mapB = {for (var item in listFromDB) item.id: item};
  //
  //   return listFromServer.map((item) => mapB.containsKey(item.id) ? mapB[item.id]! : item).toList();
  // }

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

}
