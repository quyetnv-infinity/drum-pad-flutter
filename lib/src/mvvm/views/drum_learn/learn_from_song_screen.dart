// import 'package:ads_tracking_plugin/collapsible_banner_ad/collapsible_banner_ad_widget.dart';
import 'package:drumpad_flutter/core/res/drawer/image.dart';
import 'package:drumpad_flutter/core/utils/locator_support.dart';
import 'package:drumpad_flutter/src/mvvm/models/category_model.dart';
import 'package:drumpad_flutter/src/mvvm/view_model/category_provider.dart';
import 'package:drumpad_flutter/src/mvvm/view_model/drum_learn_provider.dart';
import 'package:drumpad_flutter/src/mvvm/view_model/purchase_provider.dart';
import 'package:drumpad_flutter/src/mvvm/views/drum_learn/widget/list_song_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LearnFromSongScreen extends StatefulWidget {
  final bool isChooseSong;
  const LearnFromSongScreen({super.key, this.isChooseSong = false});

  @override
  State<LearnFromSongScreen> createState() => _LearnFromSongScreenState();
}

class _LearnFromSongScreenState extends State<LearnFromSongScreen> {
  List<Category> listCategories = [];

  @override
  void initState() {
    super.initState();
    fetchDataCategory();
  }

  Future<void> fetchDataCategory() async {
    final categoryProvider = Provider.of<CategoryProvider>(context, listen: false);
    if(categoryProvider.categories.isEmpty) {
      await categoryProvider.fetchCategories();
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<DrumLearnProvider>(context, listen: true);
    return Scaffold(
      // bottomNavigationBar: Consumer<PurchaseProvider>(
      //   builder: (context, purchaseProvider, _) {
      //     return !purchaseProvider.isSubscribed ? const SafeArea(child: CollapsibleBannerAdWidget(adName: "banner_collap_all")) : const SizedBox.shrink();
      //   }
      // ),
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leadingWidth: 100,
        toolbarHeight: 50,
        backgroundColor: Colors.transparent,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context, );
          },
          child: Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Row(
              children: [
                Icon(Icons.arrow_back_ios, color: Colors.white, size: 22),
                Text(context.locale.back, style: TextStyle(color: Colors.white, fontSize: 17),)
              ],
            ),
          ),
        ),
        title: Text(widget.isChooseSong ? context.locale.choose_song : context.locale.learn_from_song, style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700),)
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(image: DecorationImage(image: AssetImage(ResImage.imgBG),fit: BoxFit.cover)),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Consumer<CategoryProvider>(
              builder: (context, categoryProvider, _) {
                return Column(
                  spacing: 16,
                  children: [
                    if(provider.listSongResume.isNotEmpty) ListSongWidget(title: context.locale.resume, isMore: false, isChooseSong: widget.isChooseSong, listSongData: provider.listSongResume),
                    if(categoryProvider.isLoading) Center(child: CupertinoActivityIndicator()),
                    if(categoryProvider.categories.isNotEmpty)
                      ...categoryProvider.categories.map((category) {
                        return ListSongWidget(
                          title: category.name,
                          isMore: true,
                          categoryCode: category.code,
                          isChooseSong: widget.isChooseSong,
                          listSongData: [],
                        );
                      }),
                  ],
                );
              }
            ),
          ),
        ),
      ),
    );
  }
}
