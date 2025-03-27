import 'package:drumpad_flutter/core/res/drawer/icon.dart';
import 'package:drumpad_flutter/core/res/drawer/image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class OptionsWidget extends StatelessWidget {
  final String title;
  final String description;
  final String asset;
  final Function func;
  const OptionsWidget({super.key, required this.title, required this.description, required this.asset, required this.func});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => func(),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16),
        padding: EdgeInsets.symmetric(horizontal: 26, vertical: 22),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(16),
        image: DecorationImage(image: AssetImage(asset))
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              flex: 3,
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 4,
                children: [
                  Text(title, style: TextStyle(color: Colors.white, fontSize: 23, fontWeight: FontWeight.w700)),
                  Text(description, style: TextStyle(color: Colors.white, fontSize: 15), maxLines: 2, overflow: TextOverflow.ellipsis,)
                ],
              ),
            ),
            Flexible(
              flex: 1,
              child: SvgPicture.asset(ResIcon.icExpand))
          ],
        ),
      ),
    );
  }
}
