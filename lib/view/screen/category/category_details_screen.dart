import 'package:and_drum_pad_flutter/core/res/drawer/icon.dart';
import 'package:and_drum_pad_flutter/view/widget/button/icon_button_custom.dart';
import 'package:and_drum_pad_flutter/view/widget/scaffold/custom_scaffold.dart';
import 'package:flutter/material.dart';

class CategoryDetailsScreen extends StatelessWidget {
  const CategoryDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("funkl"),
        leadingWidth: 48,
        leading: Padding(
          padding: EdgeInsets.symmetric(vertical: 12).copyWith(left: 16),
          child: IconButtonCustom(iconAsset: ResIcon.icBack, onTap: () {
            Navigator.pop(context);
          },),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: IconButtonCustom(iconAsset: ResIcon.icIap, onTap: () {
              Navigator.pop(context);
            },),
          ),
        ],
      ),
      body: IconButtonCustom(iconAsset: ResIcon.icBack, onTap: () {
        Navigator.pop(context);
      },),
    );
  }
}
