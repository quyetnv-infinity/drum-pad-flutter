import 'package:drumpad_flutter/src/mvvm/view_model/drum_learn_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ComboText extends StatefulWidget {
  const ComboText({super.key, });

  @override
  State<ComboText> createState() => _ComboTextState();
}

class _ComboTextState extends State<ComboText> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scoreAnimation;
  double _previousScore = 0.0; // Lưu giá trị trước đó
  double comboPoint = 0;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 250), // Animation nhanh hơn 500ms
      vsync: this,
    );

    _setUpAnim(0, context
        .read<DrumLearnProvider>()
        .increaseScoreByCombo
        .toDouble());

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _animationController.forward();
    });
  }

// Hàm cập nhật animation khi điểm thay đổi
  void _setUpAnim(double start, double end) {
    _scoreAnimation = Tween<double>(
      begin: start,
      end: end,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));
    _animationController.forward(from: 0); // Restart animation
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DrumLearnProvider>(
      builder: (context, provider, child) {
        double newScore = provider.increaseScoreByCombo.toDouble();

        if (_previousScore != newScore) {
          _setUpAnim(_previousScore, newScore);
          _previousScore = newScore;
          if(newScore != 0){
            comboPoint = newScore;
          }
          if(newScore == 0){
            WidgetsBinding.instance.addPostFrameCallback((_) async {
              print('_previousScore $comboPoint');
            });
          }
        }
        return provider.increaseScoreByCombo > 0 ? AnimatedBuilder(
          animation: _scoreAnimation,
          builder: (context, child) {
            return Text(
              _scoreAnimation.value.toStringAsFixed(0),
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 32,
                color: Colors.white,
              ),
            );
          },
        ): SizedBox.shrink();
      },
    );
  }
}
