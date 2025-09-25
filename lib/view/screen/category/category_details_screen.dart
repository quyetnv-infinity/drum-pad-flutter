import 'package:ads_tracking_plugin/tracking/services/screen_logger.dart';
import 'package:ads_tracking_plugin/tracking/services/screen_time_tracker.dart';
import 'package:and_drum_pad_flutter/core/res/drawer/icon.dart';
import 'package:and_drum_pad_flutter/data/model/category_model.dart';
import 'package:and_drum_pad_flutter/view/screen/drum_pad_play/runner_play/drum_pad_play_screen.dart';
import 'package:and_drum_pad_flutter/view/widget/app_bar/custom_app_bar.dart';
import 'package:and_drum_pad_flutter/view/widget/button/icon_button_custom.dart';
import 'package:and_drum_pad_flutter/view/widget/list_view/list_category_details.dart';
import 'package:and_drum_pad_flutter/view/widget/loading_dialog/loading_dialog.dart';
import 'package:and_drum_pad_flutter/view/widget/scaffold/custom_scaffold.dart';
import 'package:and_drum_pad_flutter/view_model/category_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CategoryDetailsScreen extends StatefulWidget {
  final Category category;
  final Function(bool showRateApp)? rateApp;
  const CategoryDetailsScreen({super.key, required this.category, this.rateApp});

  @override
  State<CategoryDetailsScreen> createState() => _CategoryDetailsScreenState();
}

class _CategoryDetailsScreenState extends State<CategoryDetailsScreen> with ScreenLogger<CategoryDetailsScreen>, ScreenTimeLogger<CategoryDetailsScreen> {
  bool _showRateApp = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final provider = Provider.of<CategoryProvider>(context, listen: false);
      provider.fetchItemByCategory(categoryCode: widget.category.code);
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: CustomAppBar(
        title: widget.category.name,
        iconLeading: ResIcon.icBack,
        onTapLeading: () {
          Navigator.pop(context);
          if(_showRateApp) widget.rateApp?.call(true);
        },
      ),
      body: Consumer<CategoryProvider>(
        builder: (context, provider, _) {
          return ListCategoryDetails(
            category: provider.categories.firstWhere((element) => element.code == widget.category.code,),
            onTapItem: (song) {
               showDialog(context: context, builder: (context) => LoadingDataScreen(
                  callbackLoadingCompleted: (song) async {
                    Navigator.pop(context);
                    final result = await Navigator.push(context, MaterialPageRoute(builder: (context) => DrumPadPlayScreen(songCollection: song)));
                    if(result) {
                      setState(() {
                        _showRateApp = result;
                      });
                    }
                  },
                  callbackLoadingFailed: () {
                    Navigator.pop(context);
                  },
                  song: song
                )
              );
            },
          );
        }
      )
    );
  }
}
