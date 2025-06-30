import 'package:and_drum_pad_flutter/core/res/drawer/icon.dart';
import 'package:and_drum_pad_flutter/core/res/style/text_style.dart';
import 'package:and_drum_pad_flutter/core/utils/locator_support.dart';
import 'package:and_drum_pad_flutter/data/model/theme_model.dart';
import 'package:and_drum_pad_flutter/view/screen/setting/setting_screen.dart';
import 'package:and_drum_pad_flutter/view/screen/theme/widget/theme_widget.dart';
import 'package:and_drum_pad_flutter/view/screen/theme_detail/theme_detail_screen.dart';
import 'package:and_drum_pad_flutter/view/widget/app_bar/custom_app_bar.dart';
import 'package:and_drum_pad_flutter/view/widget/button/icon_button_custom.dart';
import 'package:and_drum_pad_flutter/view/widget/scaffold/custom_scaffold.dart';
import 'package:flutter/material.dart';

class ThemeScreen extends StatelessWidget {
  const ThemeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    print("ThemeScreen build");
    return AppScaffold(
      appBar: AppBar(
        leadingWidth: MediaQuery.sizeOf(context).width * 0.5,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16, top: 10),
          child: Text(context.locale.drum_theme, maxLines: 1, overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize:20, fontFamily: AppFonts.commando, color: Colors.white)),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 0),
            child: IconButtonCustom(iconAsset: ResIcon.icSetting, onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => SettingScreen()));
            },),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 16,
          children: [
            Text(context.locale.list_themes, style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontWeight: FontWeight.w600, fontSize: 14),),
            Expanded(
              child: GridView.builder(
                itemCount: listThemes.length,
                shrinkWrap: true,
                padding: EdgeInsets.only(bottom: kBottomNavigationBarHeight + 100),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 2/3,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8
                ),
                itemBuilder: (context, index) {
                  final theme = listThemes[index];
                  return _buildThemeItem(context, theme);
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildThemeItem(BuildContext context, ThemeModel theme) {
    return Container(
      padding: EdgeInsets.only(top: 12, bottom: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
        gradient: RadialGradient(colors: [
          Color(0xFF220C2B), Color(0xFF1E002A)
        ])
      ),
      child: Column(
        spacing: 12,
        children: [
          Expanded(child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: ThemeWidget(
              theme: theme,
              widthPad: MediaQuery.of(context).size.width / 2 - 130,
            ),
          )),
          InkWell(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => ThemeDetailScreen(theme: theme),));
            },
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 8),
              margin: EdgeInsets.symmetric(horizontal: 8),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                gradient: LinearGradient(colors: [
                  Color(0xFFD796FF), Color(0xFFA005FF)
                ], begin: Alignment.centerRight, end: Alignment.centerLeft)
              ),
              child: Text(context.locale.get_theme, style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600),),
            ),
          )
        ],
      ),
    );
  }
}
