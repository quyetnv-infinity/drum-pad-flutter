import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
class IconButtonCustom extends StatelessWidget {
  final String iconAsset;
  final VoidCallback onTap;

  const IconButtonCustom({
    super.key,
    required this.iconAsset,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 28,
      width: 28,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(100),
          child: Container(
            padding: EdgeInsets.all(4),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withValues(alpha: 0.1),
              border: Border.all(color: Colors.white.withValues(alpha: 0.2), width: 1),
            ),
            child: SvgPicture.asset(
              iconAsset,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}
