import 'package:drumpad_flutter/core/constants/app_info.dart';
import 'package:flutter/material.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:shared_preferences/shared_preferences.dart';

const KEY = 'FIRST_TIME_OPEN';

class RateAppProvider with ChangeNotifier {
  late SharedPreferences _prefs;
  final InAppReview _inAppReview = InAppReview.instance;

  Future<bool> isSecondTimeOpen() async {
    _prefs = await SharedPreferences.getInstance();
    try {
      dynamic isSecondTime = _prefs.getBool(KEY) as bool;
      if(isSecondTime != null && !isSecondTime){
        _prefs.setBool(KEY, false);
        return false;
      } else if(isSecondTime != null && isSecondTime){
        _prefs.setBool(KEY, false);
        return true;
      } else {
        _prefs.setBool(KEY, true);
        return false;
      }
    } catch (e){
      return false;
    }
  }

  Future<bool> showRating() async {
    try {
      final available = await _inAppReview.isAvailable();
      if(available) {
        print('requestReview');
        await _inAppReview.requestReview();
      } else {
        print('openStoreListing');
        await _inAppReview.openStoreListing(appStoreId: AppInfo.appId);
      }
      print('rate true');
      return true;
    } catch (e){
      return false;
    }
  }
}