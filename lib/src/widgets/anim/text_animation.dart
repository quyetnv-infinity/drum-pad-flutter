import 'package:flutter/material.dart';

class ScaleEffectWidget extends StatefulWidget {
  final Widget child;

  const ScaleEffectWidget({Key? key, required this.child}) : super(key: key);

  @override
  _ScaleEffectWidgetState createState() => _ScaleEffectWidgetState();
}

class _ScaleEffectWidgetState extends State<ScaleEffectWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _scaleAnimation = TweenSequence([
      TweenSequenceItem(tween: Tween<double>(begin: 1.0, end: 2.0), weight: 50),
      TweenSequenceItem(tween: Tween<double>(begin: 2.0, end: 1.5), weight: 50),
    ]).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _controller.forward(); // Chạy animation ngay khi widget được tạo
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: widget.child,
        );
      },
    );
  }
}
