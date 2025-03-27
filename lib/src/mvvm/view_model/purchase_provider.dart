import 'package:ads_tracking_plugin/ads_controller.dart';
import 'package:ads_tracking_plugin/ads_tracking_plugin.dart';
import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

// sub
const String monthlySubscription = "sub.monthly.aifusion.infinity";
const String yearlySubscription = "sub.yearly.aifusion.infinity";

class PurchaseProvider with ChangeNotifier {
  final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  List<ProductDetails> _products = [];
  bool _isSubscribed = false;
  bool _isLoading = false;

  List<ProductDetails> get products => _products;
  bool get isSubscribed => _isSubscribed;
  bool get isLoading => _isLoading;

  PurchaseProvider() {
    _initRevenueCat().then((_) {
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
    final bool available = await _inAppPurchase.isAvailable();
    if (!available) {
      // Store không khả dụng
      print('Store is not available');
      return;
    }

    const Set<String> ids = {yearlySubscription, monthlySubscription};
    final ProductDetailsResponse response = await _inAppPurchase.queryProductDetails(ids);
    if (response.error != null) {
      print('Error: ${response.error!.message}');
      return;
    }

    _products = response.productDetails;
    notifyListeners();
  }

  Future<void> _initRevenueCat() async {
    try {
      Purchases.setLogLevel(LogLevel.verbose);
      await Purchases.configure(PurchasesConfiguration('appl_EBXatlNPISrhWcwJkQIOaTPfedU'));
    } catch(e) {
      print("_initRevenueCat: $e");
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
      print("Restore failed: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> purchaseSubscription(String subID) async {
    try {
      _isLoading = true;
      notifyListeners();

      // Fetch offerings from RevenueCat
      Offerings offerings = await Purchases.getOfferings();

      // Duyệt qua tất cả các Offering và Package để tìm StoreProduct
      StoreProduct? targetProduct;
      for (var offering in offerings.all.values) {
        for (var package in offering.availablePackages) {
          if (package.storeProduct.identifier == subID) {
            targetProduct = package.storeProduct;
            break;
          }
        }
      }

      // Kiểm tra xem sản phẩm có tồn tại không
      if (targetProduct == null) {
        throw Exception("Product with identifier '$subID' not found.");
      }

      // Thực hiện mua gói
      await Purchases.purchaseStoreProduct(targetProduct);
      print("Subscription successful!");

      // Cập nhật trạng thái đăng ký
      await _checkSubscriptionStatus();
      AnalyticsUtil.logEvent("sub_purchase");
    } catch (e) {
      print("Purchase failed: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _checkSubscriptionStatus() async {
    try {
      // Lấy thông tin người dùng
      final customerInfo = await Purchases.getCustomerInfo();
      print("_checkSubscriptionStatus: ${customerInfo.activeSubscriptions}");

      if (customerInfo.activeSubscriptions.contains(yearlySubscription)
          || customerInfo.activeSubscriptions.contains(monthlySubscription)
      ) {
        _isSubscribed = true;
      } else {
        _isSubscribed = false;
      }
    } catch (e) {
      print('Lỗi khi kiểm tra subscription: $e');
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
