import 'package:flutter/material.dart';

class GradientButton extends StatelessWidget {
  final Function() onPressed;
  final Widget child;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final BorderRadiusGeometry? borderRadius;
  final List<BoxShadow>? boxShadow;
  final Gradient? gradient;
  final BoxShape shape;
  final AlignmentGeometry? alignment;
  final BoxBorder? border;

  const GradientButton(
      {super.key,
      required this.onPressed,
      required this.child,
      this.width,
      this.height,
      this.padding,
      this.margin,
      this.borderRadius,
      this.boxShadow,
      this.gradient = const LinearGradient(
        colors: [
          Color(0xFF5A2CE4),
          Color(0xFF8031E1),
        ],
      ),
      this.shape = BoxShape.rectangle,
      this.alignment,
      this.border});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      splashFactory: NoSplash.splashFactory,
      onTap: onPressed,
      child: Container(
        padding: padding,
        margin: margin,
        width: width,
        height: height,
        alignment: alignment,
        decoration: BoxDecoration(
          borderRadius: borderRadius,
          boxShadow: boxShadow,
          gradient: gradient,
          shape: shape,
          border: border,
        ),
        child: child,
      ),
    );
  }
}
