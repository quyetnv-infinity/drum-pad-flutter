import 'package:drumpad_flutter/core/utils/locator_support.dart';
import 'package:flutter/material.dart';

class UnlockDialog extends StatelessWidget {
  final Function() onConfirm;
  final Function() onCancel;

  const UnlockDialog({super.key, required this.onConfirm, required this.onCancel});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 16,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              context.locale.unlock_question,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF007AFF)),
            ),
            const SizedBox(height: 14),
            Text(
              context.locale.item_locked_watch_video_to_unlock,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Color(0xFF434343)),
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: CustomButton(
                    mode: CustomButtonMode.outline,
                    label: context.locale.cancel,
                    onPressed: () {
                      onCancel();
                    },
                    color: const Color(0xFF007AFF),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: CustomButton(
                    label: context.locale.watch_ads,
                    onPressed: () {
                      onConfirm();
                    },
                    color: const Color(0xFF007AFF),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

enum CustomButtonMode {
  contained,
  outline
}

class CustomButton extends StatelessWidget {
  final String label;
  final Color? color;
  final Color? labelColor;
  final Function()? onPressed;
  final CustomButtonMode? mode;

  const CustomButton({super.key, required this.label, this.color, this.labelColor, this.onPressed, this.mode = CustomButtonMode.contained});

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(99),
          border: Border.all(width: 1, color: color ?? Colors.blue)
      ),
      child: Material(
        borderRadius: BorderRadius.circular(99),
        color: mode != CustomButtonMode.outline ? color ?? (mode == CustomButtonMode.outline ? Colors.transparent : Colors.blue) : Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(label, textAlign: TextAlign.center, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(color: labelColor ?? (mode == CustomButtonMode.outline ? Colors.blue : Colors.white), fontWeight: FontWeight.w500)),
          ),
        ),
      ),
    );
  }
}