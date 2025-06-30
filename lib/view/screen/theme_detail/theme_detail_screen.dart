import 'package:and_drum_pad_flutter/core/res/dimen/spacing.dart';
import 'package:and_drum_pad_flutter/core/res/drawer/icon.dart';
import 'package:and_drum_pad_flutter/core/utils/locator_support.dart';
import 'package:and_drum_pad_flutter/data/model/theme_model.dart';
import 'package:and_drum_pad_flutter/view/screen/theme/widget/theme_widget.dart';
import 'package:and_drum_pad_flutter/view/widget/app_bar/custom_app_bar.dart';
import 'package:and_drum_pad_flutter/view/widget/scaffold/custom_scaffold.dart';
import 'package:and_drum_pad_flutter/view_model/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ThemeDetailScreen extends StatelessWidget {
  final ThemeModel theme;
  const ThemeDetailScreen({super.key, required this.theme});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: CustomAppBar(
        title: context.locale.theme_detail,
        iconLeading: ResIcon.icBack,
        onTapLeading: () {
          Navigator.pop(context);
        },
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              ResSpacing.h56,
              ThemeWidget(theme: theme, widthPad: (MediaQuery.of(context).size.width - 32)/2),
              Spacer(),
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Consumer<ThemeProvider>(
                  builder: (context, provider, _) {
                    return InkWell(
                      borderRadius: BorderRadius.circular(30),
                      onTap: () {
                        showDialogApplyTheme(context, provider);
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 76, vertical: 16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          gradient: LinearGradient(colors: [
                            Color(0xFFA005FF), Color(0xFFD796FF)
                          ])
                        ),
                        child: Text(provider.themeId == theme.id ? context.locale.theme_applied : context.locale.apply_theme, style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 16),),
                      ),
                    );
                  }
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void showDialogApplyTheme(BuildContext context, ThemeProvider provider) {
    if(provider.themeId == theme.id) return;
    provider.themeId = theme.id;
    showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.8),
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            padding: EdgeInsets.only(bottom: 12, top: 24, right: 16, left: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(32),
              gradient: RadialGradient(colors: [Color(0xFF33114D), Color(0xFF7727B3)], center: Alignment.bottomCenter)
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset('assets/images/img_theme_dialog.png', width: MediaQuery.of(context).size.width * 0.4,),
                ResSpacing.h20,
                Text(context.locale.theme_applied_successfully, style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500), textAlign: TextAlign.center,),
                ResSpacing.h4,
                Text(context.locale.theme_applied_successfully_description, style: TextStyle(color: Colors.white.withValues(alpha: 0.6), fontSize: 12, fontWeight: FontWeight.w500), textAlign: TextAlign.center,),
                ResSpacing.h24,
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 100, vertical: 16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      gradient: LinearGradient(colors: [Color(0xFFA005FF), Color(0xFFD796FF)])
                    ),
                    child: Text(context.locale.ok.toUpperCase(), style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 16),),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
