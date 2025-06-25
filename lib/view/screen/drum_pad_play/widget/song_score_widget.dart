import 'dart:async';

import 'package:and_drum_pad_flutter/core/res/drawer/image.dart';
import 'package:and_drum_pad_flutter/core/utils/locator_support.dart';
import 'package:and_drum_pad_flutter/data/model/lesson_model.dart';
import 'package:and_drum_pad_flutter/data/service/api_service/api_service.dart';
import 'package:and_drum_pad_flutter/view/widget/star/star_result.dart';
import 'package:and_drum_pad_flutter/view/widget/text/judgement_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class SongScoreWidget extends StatefulWidget {
  final SongCollection songCollection;
  final double starPercent;
  final int score;
  final int perfectPoint;
  const SongScoreWidget({super.key, required this.songCollection, required this.starPercent, required this.score, required this.perfectPoint});

  @override
  State<SongScoreWidget> createState() => _SongScoreWidgetState();
}

class _SongScoreWidgetState extends State<SongScoreWidget> with TickerProviderStateMixin {
  late final AnimationController _rotationController;
  late final AnimationController _starBounceController;
  late final AnimationController _scoreBounceController;
  late final AnimationController _perfectBounceController;
  late Animation<double> _starScaleAnimation;
  late Animation<double> _perfectScaleAnimation;
  late Animation<double> _scoreScaleAnimation;

  double _oldStarPercent = 0;
  bool showPerfect = false;
  Timer? _hidePerfectTimer;

  @override
  void initState() {
    super.initState();

    // Xoay hình tròn
    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();

    // Controller cho hiệu ứng bounce khi starPercent thay đổi
    _starBounceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _scoreBounceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _perfectBounceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    // Tạo animation scale bounce
    _starScaleAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.2).chain(CurveTween(curve: Curves.easeOut)), weight: 50),
      TweenSequenceItem(tween: Tween(begin: 1.2, end: 1.0).chain(CurveTween(curve: Curves.bounceOut)), weight: 50),
    ]).animate(_starBounceController);
    _scoreScaleAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.2).chain(CurveTween(curve: Curves.easeOut)), weight: 50),
      TweenSequenceItem(tween: Tween(begin: 1.2, end: 1.0).chain(CurveTween(curve: Curves.bounceOut)), weight: 50),
    ]).animate(_scoreBounceController);
    _perfectScaleAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.5).chain(CurveTween(curve: Curves.easeOut)), weight: 50),
      TweenSequenceItem(tween: Tween(begin: 1.5, end: 1.0).chain(CurveTween(curve: Curves.bounceOut)), weight: 50),
    ]).animate(_perfectBounceController);
    if (widget.perfectPoint >= 3) {
      showPerfect = true;
      _perfectBounceController.forward();
    }
  }

  @override
  void didUpdateWidget(covariant SongScoreWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    final newPercent = widget.starPercent;
    final oldPercent = _oldStarPercent;

    // Danh sách các mốc cần trigger animation
    final milestones = [45, 75, 100];

    for (final milestone in milestones) {
      if (oldPercent < milestone && newPercent >= milestone) {
        _starBounceController.forward(from: 0);
        break;
      }
    }
    if (widget.score != oldWidget.score) {
      _scoreBounceController.forward(from: 0);
    }
    if (widget.perfectPoint >= 3) {
      setState(() {
        showPerfect = true;
      });

      _perfectBounceController.forward(from: 0);

      // Huỷ timer cũ nếu có, rồi đặt lại timer mới 2s
      _hidePerfectTimer?.cancel();
      _hidePerfectTimer = Timer(const Duration(seconds: 2), () {
        if (mounted) {
          setState(() {
            showPerfect = false;
          });
        }
      });
    }

    _oldStarPercent = newPercent;
  }

  @override
  void dispose() {
    _rotationController.dispose();
    _perfectBounceController.dispose();
    _scoreBounceController.dispose();
    _starBounceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenW = MediaQuery.sizeOf(context).width;

    return Stack(
      alignment: Alignment.center,
      children: [
        Align(
          alignment: Alignment.centerRight,
          child: Image.asset(
            ResImage.imgBgSongScore,
            height: screenW * 0.5,
            fit: BoxFit.cover,
          ),
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: RotationTransition(
            turns: _rotationController,
            child: Container(
              width: screenW * 0.43,
              height: screenW * 0.43,
              clipBehavior: Clip.antiAlias,
              decoration: const BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Positioned.fill(
                    child: CachedNetworkImage(
                      imageUrl: "${ApiService.BASEURL}${widget.songCollection.image}",
                      fit: BoxFit.cover,
                    ),
                  ),
                  Container(
                    height: 18,
                    width: 18,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xffd9d9d9).withValues(alpha: 0.3)
                    ),
                  ),
                  Container(
                    height: 12,
                    width: 12,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xff7C147F).withValues(alpha: 0.8)
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          right: screenW * 0.068,
          bottom: 10,
          child: _buildScore(),
        ),
        if(showPerfect)
        Positioned(
          right: screenW * 0.12,
          top: 10,
          child: ScaleTransition(
            scale: _perfectScaleAnimation,
            child: Transform.rotate(
              angle: -0.16,
              child: JudgementText.perfect(
                context.locale.perfect,
                italic: true,
                fontSize: 28,
                underline: true,
              ),
            ),
          ),
        ),
      ],
    );
  }
  Widget _buildScore(){
    return
      Column(
        children: [
          ScaleTransition(
            scale: _starScaleAnimation,
            child: RatingStars.custom(value: widget.starPercent, paddingMiddle: 20, smallStarWidth: 38, smallStarHeight: 38, bigStarWidth: 38, bigStarHeight: 38, isFlatStar: true)),
          Text(context.locale.score_string, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),),
          ScaleTransition(
            scale: _scoreScaleAnimation,
            child: Text(widget.score.toString(), style: TextStyle(fontSize: 40, fontWeight: FontWeight.w700),))
        ],
      );
  }
}
