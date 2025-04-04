import 'package:drumpad_flutter/core/res/style/text_style.dart';
import 'package:drumpad_flutter/core/utils/locator_support.dart';
import 'package:drumpad_flutter/src/mvvm/views/profile/widget/carousel_widget.dart';
import 'package:drumpad_flutter/src/widgets/scaffold/custom_scaffold.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      backgroundType: BackgroundType.gradient,
      backgroundFit: BoxFit.cover,
      appBar: AppBar(
          leadingWidth: 100,
        toolbarHeight: 50,
        backgroundColor: Colors.transparent,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
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
        title: Text(
          context.locale.your_profile,
          style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700),
        )
      ),
      body: Column(
        children: [
          CarouselWidget()
        ],
      ),
    );
  }
}
