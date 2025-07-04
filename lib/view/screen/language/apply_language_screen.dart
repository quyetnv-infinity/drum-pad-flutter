import 'dart:io';

import 'package:and_drum_pad_flutter/core/enum/language_enum.dart';
import 'package:and_drum_pad_flutter/core/res/dimen/spacing.dart';
import 'package:and_drum_pad_flutter/core/utils/locator_support.dart';
import 'package:and_drum_pad_flutter/view/screen/language/widget/other_language_container.dart';
import 'package:and_drum_pad_flutter/view/widget/app_bar/custom_app_bar.dart';
import 'package:and_drum_pad_flutter/view/widget/scaffold/custom_scaffold.dart';
import 'package:and_drum_pad_flutter/view_model/locale_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ApplyLanguageScreen extends StatefulWidget {
  final Function() onCompleted;
  const ApplyLanguageScreen({super.key, required this.onCompleted,});

  @override
  State<ApplyLanguageScreen> createState() => _ApplyLanguageScreenState();
}

class _ApplyLanguageScreenState extends State<ApplyLanguageScreen> {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Future.delayed(Duration(seconds: 2), () {
        widget.onCompleted();
      },);
    },);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        exit(0);
      },
      child: AppScaffold(
        appBar: AppBar(
          leading: Row(
            children: [
              ResSpacing.w16,
              Text(context.locale.language, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: Colors.white),),
            ],
          ),
          leadingWidth: MediaQuery.of(context).size.width,
        ),
        body: Column(
          children: [
            ResSpacing.h48,
            Consumer<LocateViewModel>(
              builder: (context, provider, _) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: OtherLanguageContainer(value: provider.selectedLanguage ?? LanguageEnum.en, onLanguageChanged: (language) {}, languageSelected: provider.selectedLanguage ?? LanguageEnum.en),
                );
              }
            ),
            Spacer(),
            Column(
              spacing: 24,
              children: [
                CircularProgressIndicator(color: Colors.blueAccent,),
                Text('Applying selected language...', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 16),)
              ],
            ),
            Spacer()
          ],
        ),
      ),
    );
  }
}
