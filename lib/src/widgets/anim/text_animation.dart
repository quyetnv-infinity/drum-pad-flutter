import 'package:drumpad_flutter/core/utils/locator_support.dart';
import 'package:drumpad_flutter/src/mvvm/view_model/drum_learn_provider.dart';
import 'package:drumpad_flutter/src/widgets/text/judgement_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ComboWidget extends StatefulWidget {
  @override
  _ComboWidgetState createState() => _ComboWidgetState();
}

class _ComboWidgetState extends State<ComboWidget> {
  final ValueNotifier<double> _scaleNotifier = ValueNotifier(1.0);
  int _lastPerfectPoint = 0;
  int perfectPoint = 0;


  @override
  Widget build(BuildContext context) {
    return Center(
      child: Consumer<DrumLearnProvider>(
        builder: (context, provider, child) {
          if (!provider.isCombo) return const SizedBox.shrink();

          // Khi perfectPoint thay đổi, kích hoạt animation scale
          if (provider.perfectPoint != _lastPerfectPoint && provider.perfectPoint >=3) {
            _lastPerfectPoint = provider.perfectPoint;
            _scaleNotifier.value = 2.0;
            if(provider.perfectPoint >= 3 && provider.perfectPoint != perfectPoint) {
              perfectPoint = provider.perfectPoint;
            }
            Future.delayed(const Duration(milliseconds: 150), () {
              _scaleNotifier.value = 1.0;
            });
          }

          return Container(
            height: double.infinity,
            width: double.infinity,
            color: Colors.black.withValues(alpha: 0.6),
            child: ValueListenableBuilder<double>(
              valueListenable: _scaleNotifier,
              builder: (context, scale, child) {
                return AnimatedScale(
                  scale: scale,
                  duration: const Duration(milliseconds: 150),
                  curve: Curves.easeOut,
                  child: Transform.rotate(
                    angle: -0.1,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Align(
                          alignment: Alignment.center,
                          child: JudgementText.perfect(
                            context.locale.perfect,
                            italic: true,
                            fontSize: 28,
                            underline: true,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 18),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                'x',
                                style: GoogleFonts.shrikhand(
                                  textStyle: const TextStyle(fontSize: 20, color: Colors.white),
                                ),
                              ),
                              Text(
                                perfectPoint.toString(),
                                style: GoogleFonts.shrikhand(
                                  textStyle: const TextStyle(fontSize: 28, color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _scaleNotifier.dispose();
    super.dispose();
  }
}
