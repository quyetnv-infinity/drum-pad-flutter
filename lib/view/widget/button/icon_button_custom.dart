import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class IconButtonCustom extends StatelessWidget {
  final String iconAsset;
  final Function() onTap;
  const IconButtonCustom({super.key, required this.iconAsset, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap(),
      child: Container(
        height: 28,
        width: 28,
        padding: EdgeInsets.all(4),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white.withValues(alpha: 0.1),
          border: Border.all(color: Colors.white, width: 1)
        ),
        child: SvgPicture.asset(iconAsset),
      ),
    );
  }
}
