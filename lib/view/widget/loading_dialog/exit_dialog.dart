import 'package:and_drum_pad_flutter/core/res/drawer/image.dart';
import 'package:and_drum_pad_flutter/core/utils/locator_support.dart';
import 'package:flutter/material.dart';

class ExitDialog extends StatelessWidget {
  final Function() onTapCancel;
  final Function() onTapContinue;
  const ExitDialog({super.key, required this.onTapCancel, required this.onTapContinue});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12).copyWith(top: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        gradient: RadialGradient(colors: [Color(0xff33114d), Color(0xff7727b3)], center: Alignment.bottomCenter)
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(ResImage.imgBgExit),
          SizedBox(height: 20),
          Text(context.locale.leaving_so_soon, style: TextStyle(fontWeight: FontWeight.w500, color: Colors.white),),
          SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Text(context.locale.you_lose_your_progress, textAlign: TextAlign.center, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.white.withValues(alpha: 0.6))),
          ),
          SizedBox(height: 28),
          Row(
            spacing: 8,
            children: [
              Expanded(
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(30),
                    onTap: onTapContinue,
                    child: Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Text(context.locale.continue_text, style: TextStyle(fontWeight: FontWeight.w500, color: Colors.white),),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(30),
                    onTap: onTapCancel,
                    child: Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        gradient: LinearGradient(colors: [Color(0xffa005ff), Color(0xffd796ff)])
                      ),
                      child: Text(context.locale.cancel, style: TextStyle(fontWeight: FontWeight.w500, color: Colors.white),),
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
