import 'package:ads_tracking_plugin/ads_controller.dart';
import 'package:flutter/material.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';


class PurchaseProvider with ChangeNotifier {
  List<StoreProduct> _products = [];
  bool _isSubscribed = false;
  bool _isLoading = false;

  List<StoreProduct> get products => _products;
  bool get isSubscribed => _isSubscribed;
  bool get isLoading => _isLoading;

  PurchaseProvider() {
    _initRevenueCat().then((_) {
      fetchProducts();
      _checkSubscriptionStatus();
    });
  }

  Future<void> loadSubscription() async {
    _isSubscribed = await _loadSubscribed();
    notifyListeners();
  }

  void togglePurchase() {
    _isSubscribed = !_isSubscribed;
    notifyListeners();
    _saveSubscribed();
  }

  Future<void> fetchProducts() async {
    try {
      Offerings offerings = await Purchases.getOfferings();
      debugPrint("fetchProducts: offerings => ${offerings.all.keys}");

      final packages = offerings.current?.availablePackages ?? [];

      _products = packages.map((pkg) => pkg.storeProduct).toList();
      debugPrint(_products.toString());
      notifyListeners();
    } catch (e) {
      debugPrint("fetchProducts (RevenueCat) failed: $e");
    }
  }

  Future<void> _initRevenueCat() async {
    try {
      Purchases.setLogLevel(LogLevel.verbose);
      await Purchases.configure(PurchasesConfiguration('appl_DqcHsuneCoTsCJDbrLdaKUzxgDv'));
    } catch(e) {
      debugPrint("_initRevenueCat: $e");
    }
  }

  // Khôi phục giao dịch
  Future<void> restorePurchases() async {
    try {
      _isLoading = true;
      notifyListeners();

      await Purchases.restorePurchases();

      // Cập nhật lại trạng thái đăng ký sau khi khôi phục
      await _checkSubscriptionStatus();
    } catch (e) {
      debugPrint("Restore failed: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> purchaseSubscription(StoreProduct product) async {
    try {
      _isLoading = true;
      notifyListeners();

      await Purchases.purchaseStoreProduct(product);
      debugPrint("Subscription successful!");

      // Cập nhật trạng thái đăng ký
      await _checkSubscriptionStatus();
    } catch (e) {
      debugPrint("Purchase failed: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _checkSubscriptionStatus() async {
    try {
      await Purchases.syncPurchases();
      // Lấy thông tin người dùng
      final customerInfo = await Purchases.getCustomerInfo();
      debugPrint("_checkSubscriptionStatus: ${customerInfo.entitlements.active}");

      if (customerInfo.entitlements.active.isNotEmpty) {
        _isSubscribed = true;
      } else {
        _isSubscribed = false;
      }
    } catch (e) {
      debugPrint('Lỗi khi kiểm tra subscription: $e');
    }
    notifyListeners();
    _saveSubscribed();
  }

  Future<bool> _loadSubscribed() async {
    final prefs = await SharedPreferences.getInstance();
    bool? value = prefs.getBool('isSubscribed');
    return value ?? false;
  }

  Future<void> _saveSubscribed() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isSubscribed', _isSubscribed);
    AdController.shared.setAdState(_isSubscribed);
  }
}