// import 'package:ads_tracking_plugin/ads_tracking_plugin.dart';
import 'package:flutter/material.dart';

// class PurchaseProvider extends BasePurchaseProvider {
//   PurchaseProvider() : super() {
//     debugPrint("Init PurchaseProvider");
//   }
//
//   @override
//   String get revenueCatAPIKey => 'appl_DqcHsuneCoTsCJDbrLdaKUzxgDv';
// }

class PurchaseProvider with ChangeNotifier {
  bool _isSubscribed = false;
  bool _isLoading = false;
  final _products = [];

  bool get isSubscribed => _isSubscribed;
  bool get isLoading => _isLoading;
  List get products => _products;

  void updateSubscriptionStatus(bool status) {
    _isSubscribed = status;
    notifyListeners();
  }

  // Simulate loading subscription status
  Future<void> fetchProducts() async{
    // Simulate a network call or local storage retrieval
    await Future.delayed(Duration(seconds: 1));
    // Update the subscription status
    _isSubscribed = false; // Set to true if the user is subscribed
    notifyListeners();
  }
}