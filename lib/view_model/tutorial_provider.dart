import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TutorialProvider with ChangeNotifier {
  bool _isFirstTimeShowTutorial = true;
  bool get isFirstTimeShowTutorial => _isFirstTimeShowTutorial;

  bool _isFirstTimeShowTutorialLearn = true;
  bool get isFirstTimeShowTutorialLearn => _isFirstTimeShowTutorialLearn;

  TutorialProvider(){
    getFirstShowTutorialFree().then((value) {
      _isFirstTimeShowTutorial = value;
      notifyListeners();
    },);
    getFirstShowTutorialLearn().then((value) {
      _isFirstTimeShowTutorialLearn = value;
      notifyListeners();
    },);
  }

  Future<bool> getFirstShowTutorialFree() async {
    final prefs = await SharedPreferences.getInstance();
    bool? savedValue = prefs.getBool('isFirstTimeTutorial');
    print('get first show tutorial');
    return savedValue ?? true;
  }

  Future<void> setFirstShowTutorialFree() async {
    _isFirstTimeShowTutorial = false;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isFirstTimeTutorial', false);
    print('set first show tutorial');
  }

  Future<bool> getFirstShowTutorialLearn() async {
    final prefs = await SharedPreferences.getInstance();
    bool? savedValue = prefs.getBool('isFirstTimeTutorialLearn');
    print('get first show tutorial learn');
    return savedValue ?? true;
  }

  Future<void> setFirstShowTutorialLearn() async {
    _isFirstTimeShowTutorialLearn = false;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isFirstTimeTutorialLearn', false);
    print('set first show tutorial learn');
  }

}