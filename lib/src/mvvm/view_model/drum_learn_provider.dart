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

  int get perfectPoint => _perfectPoint;
  bool get isCombo => _isCombo;

  void increasePerfectPoint() {
    _perfectPoint++;
    if (_perfectPoint >= 3) {
      _isCombo = true;
      notifyListeners();

      Future.delayed(const Duration(seconds: 3), () {
        _isCombo = false;
        notifyListeners();
      });
    }
    print(_perfectPoint);
  }

  void resetPerfectPoint() {
    _perfectPoint = 0;
    notifyListeners();
  }
}
