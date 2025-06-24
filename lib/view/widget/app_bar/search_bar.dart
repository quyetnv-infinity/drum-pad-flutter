import 'package:and_drum_pad_flutter/core/res/drawer/icon.dart';
import 'package:and_drum_pad_flutter/core/utils/locator_support.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SearchBarCustom extends StatelessWidget {
  final TextEditingController textEditingController;
  final Function(String) onSearch;
  const SearchBarCustom({super.key, required this.textEditingController, required this.onSearch});

  @override
  Widget build(BuildContext context) {
    return Container(
    margin: EdgeInsets.symmetric(horizontal: 16).copyWith(bottom: 8),
    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.white.withValues(alpha: 0.1),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1), width: 1.5)
    ),
    child: Row(
      children: [
        Expanded(
          child: TextField(
            controller: textEditingController,
            onChanged: onSearch, // Gọi hàm lọc khi nhập text
            maxLength: 50,
            maxLines: 1,
            style: const TextStyle(color: Colors.white70),
            decoration: InputDecoration(
                maintainHintHeight: true,
                hintText: context.locale.find_your_song_here,
                hintStyle: TextStyle(color: Colors.white54),
                border: InputBorder.none,
                counterText: "",
                contentPadding: EdgeInsets.zero,
                isDense: true
            ),
          ),
        ),
        SvgPicture.asset(ResIcon.icSearch)
      ],
    ),
    );
  }
}
