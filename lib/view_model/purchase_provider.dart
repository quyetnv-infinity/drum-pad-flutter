import 'package:flutter/material.dart';

class PurchaseProvider with ChangeNotifier {
  bool _isSubscribed = false;
  bool get isSubscribed => _isSubscribed;

  PurchaseProvider() : super() {
    debugPrint("Init PurchaseProvider");
  }

  @override
  String get revenueCatAPIKey => 'appl_DqcHsuneCoTsCJDbrLdaKUzxgDv';
}