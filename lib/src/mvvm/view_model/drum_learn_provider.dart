import 'dart:convert';

import 'package:drumpad_flutter/core/constants/mock_up_data.dart';
import 'package:drumpad_flutter/core/res/drawer/image.dart';
import 'package:drumpad_flutter/src/mvvm/models/lesson_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
class DrumLearnProvider extends ChangeNotifier {
  List<SongCollection> data = dataSongCollections;


  int _perfectPoint = 0;
  bool _isCombo = false;
  int _increaseScoreByCombo = 0;


  int get perfectPoint => _perfectPoint;
  bool get isCombo => _isCombo;
  int get increaseScoreByCombo => _increaseScoreByCombo;

  void increasePerfectPoint() {
    _perfectPoint ++;
    if (_perfectPoint >= 3) {
      _increaseScoreByCombo = 50 * _perfectPoint;
      _isCombo = true;
      notifyListeners();
      print(_increaseScoreByCombo);

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
    _perfectPoint = 0;
    _increaseScoreByCombo = 0;
    notifyListeners();
  }
  void resetIsCombo(){
    _isCombo = false;
    notifyListeners();
  }
}
