import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ResultInformationProvider extends ChangeNotifier {
  int _perfectPoint = 0;
  int _goodPoint = 0;
  int _earlyPoint = 0;
  int _latePoint = 0;
  int _missPoint = 0;

  int get perfectPoint => _perfectPoint;
  int get goodPoint => _goodPoint;
  int get earlyPoint => _earlyPoint;
  int get latePoint => _latePoint;
  int get missPoint => _missPoint;

  ResultInformationProvider(){
    loadPoints();
  }

  int totalPoint(){
    return _perfectPoint + _goodPoint + _earlyPoint + _missPoint + _latePoint;
  }

  Future<void> loadPoints() async {
    final prefs = await SharedPreferences.getInstance();
    _perfectPoint = prefs.getInt('perfectPoint') ?? 0;
    _goodPoint = prefs.getInt('goodPoint') ?? 0;
    _earlyPoint = prefs.getInt('earlyPoint') ?? 0;
    _latePoint = prefs.getInt('latePoint') ?? 0;
    _missPoint = prefs.getInt('missPoint') ?? 0;
    totalPoint();
    notifyListeners();
  }

  Future<void> addPoints({
    int perfect = 0,
    int good = 0,
    int early = 0,
    int late = 0,
    int miss = 0
  }) async {
    final prefs = await SharedPreferences.getInstance();

    _perfectPoint += perfect;
    _goodPoint += good;
    _earlyPoint += early;
    _latePoint += late;
    _missPoint += miss;

    await prefs.setInt('perfectPoint', _perfectPoint);
    await prefs.setInt('goodPoint', _goodPoint);
    await prefs.setInt('earlyPoint', _earlyPoint);
    await prefs.setInt('latePoint', _latePoint);
    await prefs.setInt('missPoint', _missPoint);

    notifyListeners();
  }
}
