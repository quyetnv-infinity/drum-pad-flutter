import 'package:and_drum_pad_flutter/core/res/drawer/icon.dart';
import 'package:and_drum_pad_flutter/core/utils/locator_support.dart';
import 'package:and_drum_pad_flutter/view/widget/app_bar/custom_app_bar.dart';
import 'package:and_drum_pad_flutter/view/widget/scaffold/custom_scaffold.dart';
import 'package:flutter/material.dart';

class LearnMaterialScreen extends StatefulWidget {
  const LearnMaterialScreen({super.key});

  @override
  State<LearnMaterialScreen> createState() => _LearnMaterialScreenState();
}

class _LearnMaterialScreenState extends State<LearnMaterialScreen> {

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: CustomAppBar(
        iconLeading: ResIcon.icBack,
        onTapLeading: () {
          Navigator.pop(context);
        },
        title: context.locale.learn_material,
      ),
    );
  }
}
