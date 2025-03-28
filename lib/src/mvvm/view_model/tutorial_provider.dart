import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TutorialProvider with ChangeNotifier {
  bool _isFirstTimeShowTutorial = true;
  bool get isFirstTimeShowTutorial => _isFirstTimeShowTutorial;

  TutorialProvider(){
    getFirstShowTutorial().then((value) {
      _isFirstTimeShowTutorial = value;
      notifyListeners();
    },);
  }

  Future<bool> getFirstShowTutorial() async {
    final prefs = await SharedPreferences.getInstance();
    bool? savedValue = prefs.getBool('isFirstTimeTutorial');
    print('get first show tutorial');
    return savedValue ?? true;
  }

  Future<void> setFirstShowTutorial() async {
    _isFirstTimeShowTutorial = false;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isFirstTimeTutorial', false);
    print('set first show tutorial');
  }
}