import 'package:drumpad_flutter/core/res/dimen/spacing.dart';
import 'package:drumpad_flutter/core/res/drawer/icon.dart';
import 'package:drumpad_flutter/core/utils/locator_support.dart';
import 'package:drumpad_flutter/src/widgets/button/gradient_button.dart';
import 'package:drumpad_flutter/src/widgets/scaffold/custom_scaffold.dart';
import 'package:drumpad_flutter/src/widgets/star/star_result.dart';
import 'package:drumpad_flutter/src/widgets/text/judgement_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ResultScreen extends StatefulWidget {
  final int perfectScore;
  final int goodScore;
  final int earlyScore;
  final int lateScore;
  final int missScore;
  final int totalScore;

  const ResultScreen({
    super.key,
    required this.perfectScore,
    required this.goodScore,
    required this.earlyScore,
    required this.lateScore,
    required this.missScore, required this.totalScore,
  });

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen>
    with SingleTickerProviderStateMixin {
  double _percentStar = 0;
  int _totalNotes = 0;

  // Khởi tạo các biến cho animation
  late AnimationController _animationController;
  late Animation<double> _scoreAnimation;
  late Animation<double> _perfectPercentAnimation;
  late Animation<double> _goodPercentAnimation;
  late Animation<double> _earlyPercentAnimation;
  late Animation<double> _latePercentAnimation;
  late Animation<double> _missPercentAnimation;
  late Animation<double> _starAnimation;

  @override
  void initState() {
    super.initState();
    _calculateTotalNotes();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 1500),
      vsync: this,
    );

    // Thiết lập các animations
    _setupAnimations();

    // Bắt đầu animation
    _animationController.forward();
  }

  void _calculateTotalNotes() {
    _totalNotes = widget.perfectScore +
        widget.goodScore +
        widget.earlyScore +
        widget.lateScore +
        widget.missScore;

    if (_totalNotes == 0) {
      _percentStar = 0;
      return;
    }

    int totalScore = widget.totalScore;

    // Star Score (%) = [(Perfect×100 + Good×90 + Early×60 + Late×40 + Miss×0) / (Tổng số note × 100)] × 100%
    _percentStar = (totalScore / (_totalNotes * 100)) * 100;
    print('totalScore $totalScore');
  }

  void _setupAnimations() {
    // Animation cho điểm tổng
    _scoreAnimation = Tween<double>(
      begin: 0,
      end: _totalScoreDisplay.toDouble(),
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Interval(0.0, 0.8, curve: Curves.easeOutCubic),
    ));

    // Animation cho phần trăm sao
    _starAnimation = Tween<double>(
      begin: 0,
      end: _percentStar,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Interval(0.0, 0.8, curve: Curves.easeOutCubic),
    ));

    // Animation cho phần trăm các thành phần
    _perfectPercentAnimation = _createPercentAnimation(widget.perfectScore);
    _goodPercentAnimation = _createPercentAnimation(widget.goodScore);
    _earlyPercentAnimation = _createPercentAnimation(widget.earlyScore);
    _latePercentAnimation = _createPercentAnimation(widget.lateScore);
    _missPercentAnimation = _createPercentAnimation(widget.missScore);
  }

  Animation<double> _createPercentAnimation(int value) {
    return Tween<double>(
      begin: 0,
      end: _totalNotes > 0 ? (value / _totalNotes * 100) : 0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Interval(0.3, 1.0, curve: Curves.easeOutCubic),
    ));
  }

  int get _totalScoreDisplay {
    return widget.totalScore;
  }


  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: CustomScaffold(
        backgroundType: BackgroundType.gradient,
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF5A2CE4),
            Color(0xFF141414),
          ],
          stops: [0.4, 0.9],
        ),
        body: AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  context.locale.congratulation,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 27,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                // Sử dụng giá trị animation cho RatingStars
                RatingStars(value: _starAnimation.value),
                Text(
                  context.locale.final_score,
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 27),
                ),
                // Sử dụng giá trị animation cho điểm
                Text(
                  "${_scoreAnimation.value.toInt()}",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 60,
                  ),
                ),
                SizedBox(height: 18),
                _rowScore(
                  title: JudgementText.perfect(
                    context.locale.perfect,
                    textAlign: TextAlign.center,
                  ),
                  value: _perfectPercentAnimation.value,
                  count: widget.perfectScore,
                ),
                _rowScore(
                  title: JudgementText.good(
                    context.locale.good,
                    textAlign: TextAlign.center,
                  ),
                  value: _goodPercentAnimation.value,
                  count: widget.goodScore,
                ),
                _rowScore(
                  title: JudgementText.early(
                    context.locale.early,
                    textAlign: TextAlign.center,
                  ),
                  value: _earlyPercentAnimation.value,
                  count: widget.earlyScore,
                ),
                _rowScore(
                  title: JudgementText.late(
                    context.locale.late,
                    textAlign: TextAlign.center,
                  ),
                  value: _latePercentAnimation.value,
                  count: widget.lateScore,
                ),
                _rowScore(
                  title: JudgementText.miss(
                    context.locale.miss,
                    textAlign: TextAlign.center,
                  ),
                  value: _missPercentAnimation.value,
                  count: widget.missScore,
                ),
                ResSpacing.h48,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GradientButton(
                      onPressed: () {},
                      shape: BoxShape.circle,
                      padding: EdgeInsets.all(14),
                      child: SvgPicture.asset(ResIcon.icMusic),
                    ),
                    GradientButton(
                      onPressed: () {
                        Navigator.pop(context, 'play_again');
                      },
                      padding: EdgeInsets.symmetric(horizontal: 28, vertical: 16),
                      borderRadius: BorderRadius.circular(32),
                      child: Text(
                        context.locale.play_again,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    GradientButton(
                      onPressed: () {
                        /*
                          có thẻ sử dụng cách sau
                          Navigator.pushAndRemoveUntil(
                          context,
                          CupertinoPageRoute(
                            builder: (context) => HomeScreen(),
                          ),
                          (route) => false,
                        )
                        */
                        Navigator.popUntil(context, (route) => route.isFirst);
                      },
                      shape: BoxShape.circle,
                      padding: EdgeInsets.all(14),
                      child: SvgPicture.asset(ResIcon.icHome),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _rowScore(
      {required Widget title, double value = 0, required int count}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        children: [
          Expanded(flex: 2, child: title),
          Expanded(
            flex: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "${value.toStringAsFixed(0)}%",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
