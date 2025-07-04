import 'package:and_drum_pad_flutter/core/res/drawer/image.dart';
import 'package:and_drum_pad_flutter/core/res/style/text_style.dart';
import 'package:and_drum_pad_flutter/core/utils/locator_support.dart';
import 'package:flutter/material.dart';

class ModePlayItem extends StatefulWidget {
  final String asset;
  final String title;
  final String description;
  final Function() onTap;
  const ModePlayItem({super.key, required this.asset, required this.title, required this.description, required this.onTap});

  @override
  State<ModePlayItem> createState() => _ModePlayItemState();
}

class _ModePlayItemState extends State<ModePlayItem> {
  bool _isPressed = false;

  void _onTapDown(TapDownDetails details) {
    setState(() {
      _isPressed = true;
    });
  }

  void _onTapUp(TapUpDetails details) {
    setState(() {
      _isPressed = false;
    });
    widget.onTap();
  }

  void _onTapCancel() {
    setState(() {
      _isPressed = false;
    });
  }

  void _onHover(bool isHovering) {
    setState(() {
      _isPressed = isHovering;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => _onHover(true),
      onExit: (_) => _onHover(false),
      child: GestureDetector(
        onTapDown: _onTapDown,
        onTapUp: _onTapUp,
        onTapCancel: _onTapCancel,
        child: AnimatedScale(
          scale: _isPressed ? 0.95 : 1.0,
          duration: const Duration(milliseconds: 150),
          curve: Curves.easeOut,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 24),
            width: double.infinity,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white.withValues(alpha: 0.13), width: 1.5),
              borderRadius: BorderRadius.circular(12),
              image: DecorationImage(
                image: AssetImage(widget.asset),
                fit: BoxFit.cover,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.title.toUpperCase(),
                        style: const TextStyle(fontFamily: AppFonts.commando, fontSize: 16),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: Colors.white.withValues(alpha: 0.6), fontSize: 12),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Image.asset(ResImage.iconNextBtn, width: 56,height: 56, fit: BoxFit.cover,)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
