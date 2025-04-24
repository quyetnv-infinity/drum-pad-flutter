import 'package:ads_tracking_plugin/ads_controller.dart';
import 'package:ads_tracking_plugin/ads_tracking_plugin.dart';
import 'package:drumpad_flutter/core/res/drawer/icon.dart';
import 'package:drumpad_flutter/core/utils/locator_support.dart';
import 'package:drumpad_flutter/core/utils/setting_funcs.dart';
import 'package:drumpad_flutter/src/mvvm/view_model/purchase_provider.dart';
import 'package:drumpad_flutter/src/mvvm/views/iap/widget/text_gradient.dart';
import 'package:drumpad_flutter/src/widgets/overlay_loading/overlay_loading.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

class IapScreen extends StatefulWidget {
  const IapScreen({super.key});

  @override
  State<IapScreen> createState() => _IapScreenState();
}

class _IapScreenState extends State<IapScreen> with WidgetsBindingObserver {
  late PurchaseProvider _purchaseProvider;
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _purchaseProvider = Provider.of<PurchaseProvider>(context, listen: false);
    _purchaseProvider.fetchProducts();
    _purchaseProvider.addListener(_showSuccessAnimation);

    AdController.shared.setResumeAdState(true);
    WidgetsBinding.instance.addObserver(this);
  }

  void _showSuccessAnimation() {
    if (_purchaseProvider.isSubscribed && !_purchaseProvider.isLoading) {
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) {
            return AlertDialog(
                backgroundColor: Colors.transparent,
                content: Center(
                    child: Lottie.asset('assets/anim/success.json', width: 200, height: 200, fit: BoxFit.fill)
                )
            );
          }
      );
      Future.delayed(const Duration(seconds: 3), () {
        if (Navigator.canPop(context)) {
          Navigator.pop(context);
        }

        Navigator.pop(context);
      });
    }

    if (_purchaseProvider.isLoading) {
      OverlayLoading.show(context);
    } else {
      OverlayLoading.hide();
    }
  }

  @override
  void dispose() {
    _purchaseProvider.removeListener(_showSuccessAnimation);
    WidgetsBinding.instance.removeObserver(this);
    AdController.shared.setResumeAdState(false);
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _subscriptionTracking();
  }

  void _subscriptionTracking() {
    AnalyticsUtil.logEvent("sub_display");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                Image.asset('assets/images/iap_img.png'),
                SafeArea(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(left: 12),
                      child: SvgPicture.asset(ResIcon.icX),
                    ),
                  )
                ),
                SafeArea(
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Consumer<PurchaseProvider>(
                      builder: (context, purchaseProvider, _) {
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Center(child: iapText(context.locale.unlock_all_premium_features)),
                            _buildDescription(context),
                            if(purchaseProvider.products.isEmpty)
                              const CircularProgressIndicator(color: Colors.white,),
                            Column(
                              spacing: 16,
                              children: purchaseProvider.products.asMap().entries.map((entry) {
                                int index = entry.key;
                                final product = entry.value;
                                return _buildSubscriptionItem(
                                  product: product,
                                  index: index
                                );
                              }).toList()
                            ),
                            SizedBox(height: 24),
                            _buildContinueButton(
                              onTapPurchase: () {
                                if(purchaseProvider.products.isEmpty) return;
                                purchaseProvider.purchaseSubscription(purchaseProvider.products[selectedIndex]);
                              },
                            ),
                            _buildPolicyRow(
                              onTapRestore: () {
                                purchaseProvider.restorePurchases();
                              },
                            )
                          ],
                        );
                      }
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildDescription(BuildContext context){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: Column(
        spacing: 8,
        children: [
          Row(
            spacing: 10,
            children: [
              SvgPicture.asset(ResIcon.icDoneIAP),
              Text(context.locale.up_to_date_song, style: TextStyle(
                color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500
              ),)
            ],
          ),
          Row(
            spacing: 10,
            children: [
              SvgPicture.asset(ResIcon.icDoneIAP),
              Text(context.locale.new_lessons, style: TextStyle(
                  color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500
              ),)
            ],
          ),
          Row(
            spacing: 10,
            children: [
              SvgPicture.asset(ResIcon.icDoneIAP),
              Text(context.locale.new_keyboard, style: TextStyle(
                  color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500
              ),)
            ],
          )
        ],
      ),
    );
  }

  Widget _buildSubscriptionItem({required StoreProduct product, required int index}){
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedIndex = index;
        });
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16),
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
              colors: selectedIndex == index ? [Color(0xFFFFF200), Color(0xFFFD7779) ]: [Color(0xFF390966), Color(0xFF390966)]
          )
        ),
        child: Row(
          spacing: 16,
          children: [
            SvgPicture.asset( selectedIndex == index ? ResIcon.icRadioSelected : ResIcon.icRadio),
            Column(
              spacing: 4,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(product.title, style: TextStyle(color: selectedIndex == index ? Colors.black : Colors.white, fontSize: 16, fontWeight: FontWeight.w500),),
                Text("${product.priceString} / ${_parseIso8601Period(product.subscriptionPeriod ?? "P1W")}", style: TextStyle(color: selectedIndex == index ? Colors.black : Colors.white, fontSize: 18, fontWeight: FontWeight.w700),),
              ],
            )
          ],
        ),
      ),
    );
  }
  Widget _buildContinueButton({required Function() onTapPurchase}){
    return GestureDetector(
      onTap: onTapPurchase,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16),
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        decoration: BoxDecoration(
          color: Color(0xFF381A8B),
          borderRadius: BorderRadius.circular(50),
        ),
        child: Row(
          spacing: 6,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(context.locale.continuee, style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w500),),
            Icon(CupertinoIcons.arrow_right, size: 18 ,)
          ],
        ),
      ),
    );
  }
  Widget _buildPolicyRow({required Function() onTapRestore}){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          TextButton(onPressed: () {
            SettingFuncs.termsOfService();
          },
            child: Text(context.locale.term_of_use, style: TextStyle( color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600),),
          ),
          TextButton(onPressed: () {
            SettingFuncs.privacyPolicy();
          },
            child: Text(context.locale.privacy_policy, style: TextStyle( color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600),),
          ),
          /// RESTORE FUNC
          TextButton(onPressed: onTapRestore,
            child: Text(context.locale.restore, style: TextStyle( color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600),),
          ),
        ],
      ),
    );
  }


  String _parseIso8601Period(String iso8601) {
    final regex = RegExp(r'^P(\d+)([DWMY])$');
    final match = regex.firstMatch(iso8601);

    if (match == null) return 'Unknown';

    final unit = match.group(2);

    switch (unit) {
      case 'D':
        return context.locale.day.toLowerCase();
      case 'W':
        return context.locale.week.toLowerCase();
      case 'M':
        return context.locale.month.toLowerCase();
      case 'Y':
        return context.locale.year.toLowerCase();
      default:
        return 'Unknown';
    }
  }
}
