import 'package:and_drum_pad_flutter/data/model/theme_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ThemeWidget extends StatefulWidget {
  final ThemeModel theme;
  final double widthPad;
  const ThemeWidget({super.key, required this.theme, required this.widthPad});

  @override
  State<ThemeWidget> createState() => _ThemeWidgetState();
}

class _ThemeWidgetState extends State<ThemeWidget> {
  int _currentIndex = -1;

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
        return _buildItem(index);
      },
    );
  }

  Widget _buildItem(int index) {
    return GestureDetector(
      onTapDown: (_) {
        setState(() {
          _currentIndex = index;
        });
      },
      onTapUp: (_) {
        setState(() {
          _currentIndex = -1;
        });
      },
      onTapCancel: () {
        setState(() {
          _currentIndex = -1;
        });
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 1000),
        curve: Curves.easeInOut,
        transform: Matrix4.identity(),
        child: Transform.scale(
          scale: _currentIndex == index ? 0.9 : 1,
          child: _buildItemContent(index)
        ),
      ),
    );
  }

  Widget _buildItemContent(int index) {
    if(index == 2) {
      return Container(
        padding: EdgeInsets.all(4),
        decoration: BoxDecoration(
            border: Border.all(color: Colors.white),
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                  color: widget.theme.blurColor,
                  blurRadius: 8.28,
                  offset: Offset(0, 0),
                  spreadRadius: 0
              ),
              BoxShadow(
                  color: widget.theme.blurColor,
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
          child: widget.theme.assetIcon != null ? SvgPicture.asset(widget.theme.assetIcon!, height: widget.widthPad / 4, colorFilter: ColorFilter.mode(widget.theme.activeIconColor, BlendMode.srcIn),) : Container(),
        ),
      );
    }
    if(index == 4) {
      return Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            gradient: widget.theme.gradient
        ),
        alignment: Alignment.center,
        child: SvgPicture.asset('assets/icons/ic_load.svg', height: widget.widthPad / 3,),
      );
    }
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          gradient: widget.theme.gradient
      ),
      alignment: Alignment.center,
      child: widget.theme.assetIcon != null ? SvgPicture.asset(widget.theme.assetIcon!, height: widget.widthPad / 4,) : Container(),
    );
  }
}
