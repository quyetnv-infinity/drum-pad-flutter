import 'package:flutter/material.dart';

class ScorePopAnimation extends StatefulWidget {
  final int score;
  final int perfectPoint;

  const ScorePopAnimation({
    super.key,
    required this.score,
    required this.perfectPoint,
  });

  @override
  State<ScorePopAnimation> createState() => _ScorePopAnimationState();
}

class _ScorePopAnimationState extends State<ScorePopAnimation> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleY;

  int _prevPerfectPoint = 0;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _scaleY = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.3).chain(CurveTween(curve: Curves.easeOut)), weight: 30),
      TweenSequenceItem(tween: Tween(begin: 1.3, end: 0.95).chain(CurveTween(curve: Curves.easeInOut)), weight: 30),
      TweenSequenceItem(tween: Tween(begin: 0.95, end: 1.0).chain(CurveTween(curve: Curves.easeOutBack)), weight: 40),
    ]).animate(_controller);
  }

  @override
  void didUpdateWidget(covariant ScorePopAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.perfectPoint > 0 && widget.perfectPoint != _prevPerfectPoint) {
      _prevPerfectPoint = widget.perfectPoint;
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _scaleY,
      builder: (context, child) {
        return Transform.scale(
          scaleY: _scaleY.value,
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: Text(
              widget.score.toString(),
              key: ValueKey<int>(widget.score),
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 32,
                color: Colors.white,
              ),
            ),
          ),
        );
      },
    );
  }
}
