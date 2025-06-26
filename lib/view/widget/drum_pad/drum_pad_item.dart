import 'package:and_drum_pad_flutter/core/utils/locator_support.dart';
import 'package:flutter/material.dart';
import 'package:and_drum_pad_flutter/core/enum/pad_state_enum.dart';

import 'border_anim.dart';

class DrumPadItem extends StatefulWidget {
  final String sound;
  final bool isHighlighted;
  final bool hasSound;
  final bool isActive;
  final Function() onTap;
  final List<Color> colors;
  final bool isPracticeMode;
  final bool isFromBeatRunner;
  final bool shouldShowCircleProgress;
  final double circleProgressValue;
  final PadStateEnum? padState;
  final bool shouldShowSquareProgress;
  final double squareProgressValue;
  final bool shouldShowColorAnimation;
  final Animation<Color?> colorAnimation;

  const DrumPadItem({super.key, required this.sound, required this.isHighlighted, required this.hasSound, required this.isActive, required this.onTap, required this.colors, required this.isPracticeMode, required this.isFromBeatRunner, required this.shouldShowCircleProgress, required this.circleProgressValue, this.padState, required this.shouldShowSquareProgress, required this.squareProgressValue, required this.shouldShowColorAnimation, required this.colorAnimation});

  @override
  State<DrumPadItem> createState() => _DrumPadItemState();
}

class _DrumPadItemState extends State<DrumPadItem> with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (details) {
        widget.onTap();
      },
      child: Stack(
        children: [
          // Base container with gradient
          AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            curve: Curves.easeInOut,
            padding: EdgeInsets.all(widget.isActive ? 8 : 0),
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.0),
                  gradient: RadialGradient(colors: widget.colors)
              ),
            ),
          ),
          
          // Pad state display
          if (widget.padState != null)
            Center(
              child: TweenAnimationBuilder(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                tween: Tween<double>(begin: 1.0, end: widget.isActive ? 2.5 : 1.0),
                builder: (context, scale, child) {
                  return Transform.scale(
                    scale: scale,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 100),
                      curve: Curves.easeInOut,
                      transform: Matrix4.translationValues(0, -80, 0),
                      child: widget.padState!.getDisplayWidget(context),
                    ),
                  );
                },
              ),
            ),
          
          // Circle progress indicator for non-practice mode
          if (widget.shouldShowCircleProgress && !widget.isPracticeMode)
            _buildCircleProgress(context),
          
          // Square progress for beat runner mode
          if (widget.shouldShowSquareProgress && widget.hasSound && !widget.isPracticeMode && widget.isFromBeatRunner)
            Positioned.fill(
              child: CustomPaint(
                painter: SquareProgressPainter(
                  progress: widget.squareProgressValue,
                  color: Colors.white,
                  strokeWidth: 4,
                  borderRadius: 10,
                ),
              ),
            ),
          
          // Circle progress for non-beat runner mode
          if (widget.shouldShowSquareProgress && widget.hasSound && !widget.isPracticeMode && !widget.isFromBeatRunner)
            _buildNonBeatRunnerProgress(),
          
          // Color animation overlay
          if (widget.shouldShowColorAnimation)
            AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.0),
                color: widget.colorAnimation.value,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCircleProgress(BuildContext context) {
    return Stack(
      children: [
        Align(
          alignment: Alignment.center,
          child: CircularProgressIndicator(
            value: widget.circleProgressValue,
            strokeWidth: 5,
            backgroundColor: Colors.white24,
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
          ),
        ),
        Align(
          alignment: Alignment.center,
          child: Text(
            context.locale.wait, 
            style: const TextStyle(
              fontSize: 10, 
              fontWeight: FontWeight.w500, 
              color: Colors.white
            )
          )
        ),
      ],
    );
  }

  Widget _buildNonBeatRunnerProgress() {
    return Align(
      alignment: Alignment.center,
      child: SizedBox(
        width: 36,
        height: 36,
        child: CircularProgressIndicator(
          value: widget.squareProgressValue,
          strokeWidth: 5,
          backgroundColor: Colors.white24,
          valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
        ),
      ),
    );
  }
}
