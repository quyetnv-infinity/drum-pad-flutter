// import 'package:and_drum_pad_flutter/core/enum/language_enum.dart';
// import 'package:and_drum_pad_flutter/core/extension/language_extension.dart';
// import 'package:and_drum_pad_flutter/core/res/dimen/spacing.dart';
// import 'package:and_drum_pad_flutter/core/res/drawer/icon.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';
//
// class EnglishContainer extends StatefulWidget {
//   final LanguageEnum? selectedLanguage;
//   final Function(LanguageEnum value) onLanguageChanged;
//   const EnglishContainer({super.key, required this.onLanguageChanged, required this.selectedLanguage});
//
//   @override
//   State<EnglishContainer> createState() => _EnglishContainerState();
// }
//
// class _EnglishContainerState extends State<EnglishContainer> {
//   final ScrollController _scrollController = ScrollController();
//
//   static const englishOrder = [
//     LanguageEnum.enGB,
//     LanguageEnum.enUS,
//     LanguageEnum.enCA,
//     LanguageEnum.enZA,
//   ];
//
//   bool _isOpen = false;
//
//   @override
//   Widget build(BuildContext context) {
//     final height = _isOpen ? 4 * 36.0 + 24 * 3 : 0.0;
//     return Theme(
//       data: ThemeData(
//         splashColor: Colors.transparent,
//         highlightColor: Colors.transparent,
//         hoverColor: Colors.transparent,
//         focusColor: Colors.transparent,
//       ),
//       child: InkWell(
//         onTap: () {
//           setState(() {
//             if (!_isOpen) {
//               _isOpen = true;
//             } else {
//               _isOpen = false;
//             }
//           });
//         },
//         child: Column(
//           children: [
//             Container(
//               padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
//               decoration: BoxDecoration(
//                 color: Colors.white.withValues(alpha: 0.1),
//                 borderRadius: BorderRadius.circular(16),
//                 border: Border.all(color: Color(0xFFD3D3D3), width: 1)
//               ),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   Row(
//                     children: [
//                       SvgPicture.asset(
//                         LanguageEnum.en.getFlag,
//                         width: 30,
//                       ),
//                       ResSpacing.w16,
//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Text(
//                             LanguageEnum.en.displayName,
//                             style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.white),
//                           ),
//                           Text(
//                             LanguageEnum.en.localeName(context),
//                             style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: Color(0xFFD3D3D3)),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                   Row(
//                     spacing: 12,
//                     children: [
//                       SvgPicture.asset('assets/icons/english_flags.svg', height: 24,),
//                       AnimatedRotation(
//                         turns: _isOpen ? 0 : -0.25,
//                         duration: Durations.medium2,
//                         child: SvgPicture.asset(ResIcon.dropdown, width: 14,),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//             AnimatedContainer(
//               height: height.toDouble(),
//               duration: Durations.medium2,
//               padding: EdgeInsets.only(left: 16),
//               child: Scrollbar(
//                 controller: _scrollController,
//                 child: Row(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Padding(
//                       padding: const EdgeInsets.only(top: 0.0),
//                       child: Image.asset('assets/images/vertical_frame.png', height: 186, width: 14, fit: BoxFit.fill,),
//                     ),
//                     Expanded(
//                       child: ListView.separated(
//                         controller: _scrollController,
//                         padding: EdgeInsets.only(top: 22),
//                         separatorBuilder: (context, index) => ResSpacing.h8,
//                         itemCount: 4,
//                         itemBuilder: (context, index) {
//                           final item = englishOrder[index];
//                           return InkWell(
//                             onTap: () {
//                               widget.onLanguageChanged(item);
//                             },
//                             child: Container(
//                               padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//                               decoration: BoxDecoration(
//                                 color: Colors.white.withValues(alpha: 0.1),
//                                 borderRadius: BorderRadius.circular(10),
//                                 border: Border.all(color: widget.selectedLanguage == item ? Color(0xFFC84BFF) : Color(0xFFD3D3D3), width: widget.selectedLanguage == item ? 1.5 : 1)
//                               ),
//                               child: Row(
//                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   Text(
//                                     item.displayName,
//                                     style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.white),
//                                   ),
//                                   Row(
//                                     spacing: 12,
//                                     children: [
//                                       SvgPicture.asset(item.getFlag, width: 24, height: 24,),
//                                       widget.selectedLanguage == item ? SvgPicture.asset(ResIcon.icSelectCheckBoxCircle,) : SvgPicture.asset(ResIcon.icUnselectCheckBoxCircle)
//                                     ],
//                                   )
//                                 ],
//                               ),
//                             ),
//                           );
//                         },
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
