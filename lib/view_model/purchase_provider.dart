import 'package:ads_tracking_plugin/ads_tracking_plugin.dart';
import 'package:flutter/material.dart';

class PurchaseProvider extends BasePurchaseProvider {
  PurchaseProvider() : super() {
    debugPrint("Init PurchaseProvider");
  }

  @override
  String get revenueCatAPIKey => 'appl_DqcHsuneCoTsCJDbrLdaKUzxgDv';
}

/*
  import 'package:ads_tracking_plugin/ads_tracking_plugin.dart';
  import 'package:flutter/material.dart';

  class PurchaseProvider extends BasePurchaseProvider {
    PurchaseProvider() : super() {
      debugPrint("Init PurchaseProvider");
    }

    @override
    String get revenueCatAPIKey => 'appl_DqcHsuneCoTsCJDbrLdaKUzxgDv';
  }
* */