import 'package:and_drum_pad_flutter/core/enum/language_enum.dart';
import 'package:and_drum_pad_flutter/core/extension/language_extension.dart';
import 'package:and_drum_pad_flutter/core/res/drawer/icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class OtherLanguageContainer extends StatelessWidget {
  final LanguageEnum value;
  final LanguageEnum? languageSelected;
  final Function(LanguageEnum language) onLanguageChanged;
  const OtherLanguageContainer({super.key, required this.value, required this.onLanguageChanged, required this.languageSelected});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onLanguageChanged(value);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: languageSelected == value ? Color(0xFFC84BFF) : Color(0xFFD3D3D3), width: languageSelected == value ? 1.5 : 1)
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              spacing: 16,
              children: [
                SvgPicture.asset(value.getFlag, width: 30, height: 30,),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(value.displayName, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.white)),
                    Text(value.localeName(context), style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: Color(0xFFD3D3D3))),
                  ],
                ),
              ],
            ),
            languageSelected == value ? SvgPicture.asset(ResIcon.icSelectCheckBoxCircle,) : SvgPicture.asset(ResIcon.icUnselectCheckBoxCircle)
          ],
        ),
      ),
    );
  }
}
