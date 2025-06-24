import 'package:and_drum_pad_flutter/core/res/drawer/icon.dart';
import 'package:and_drum_pad_flutter/view/widget/button/icon_button_custom.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String iconLeading;
  final Function() onTapLeading;
  final String? title;
  final List<Widget>? action;
  const CustomAppBar({super.key, required this.iconLeading, required this.onTapLeading, this.title, this.action});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      title: Text(title ?? "", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16, color: Colors.white)),
      leadingWidth: 48,
      leading: Padding(
        padding: EdgeInsets.symmetric(vertical: 12).copyWith(left: 16),
        child: IconButtonCustom(iconAsset: iconLeading, onTap:
          onTapLeading
        ),
      ),
      actions: action
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}