import 'package:and_drum_pad_flutter/data/model/theme_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ThemeWidget extends StatelessWidget {
  final ThemeModel theme;
  final double widthPad;
  const ThemeWidget({super.key, required this.theme, required this.widthPad});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: 12,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 2,
        crossAxisSpacing: 4,
        childAspectRatio: 1
      ),
      itemBuilder: (context, index) {
        if(index == 2) {
          return Container(
            padding: EdgeInsets.all(4),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white),
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: theme.blurColor,
                  blurRadius: 8.28,
                  offset: Offset(0, 0),
                  spreadRadius: 0
                ),
                BoxShadow(
                  color: theme.blurColor,
                  blurRadius: 16.56,
                  offset: Offset(0, 0),
                  spreadRadius: 0
                )
              ]
            ),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Colors.white
              ),
              alignment: Alignment.center,
              child: theme.assetIcon != null ? SvgPicture.asset(theme.assetIcon!, height: widthPad / 4, colorFilter: ColorFilter.mode(theme.activeIconColor, BlendMode.srcIn),) : Container(),
            ),
          );
        }
        if(index == 4) {
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              gradient: theme.gradient
            ),
            alignment: Alignment.center,
            child: SvgPicture.asset('assets/icons/ic_load.svg', height: widthPad / 3,),
          );
        }
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            gradient: theme.gradient
          ),
          alignment: Alignment.center,
          child: theme.assetIcon != null ? SvgPicture.asset(theme.assetIcon!, height: widthPad / 4,) : Container(),
        );
      },
    );
  }
}
