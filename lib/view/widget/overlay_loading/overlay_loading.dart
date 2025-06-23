import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OverlayLoading {
  static OverlayEntry? _overlayEntry;

  // Show loading overlay
  static void show(BuildContext context) {
    if (_overlayEntry != null) return; // Avoid showing multiple overlays

    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned.fill(
        child: Container(
          color: Colors.black.withValues(alpha: 0.5),
          child: const Center(
            child: CupertinoActivityIndicator(color: Colors.white,)
          ),
        ),
      ),
    );

    // Insert overlay entry into the overlay
    Overlay.of(context).insert(_overlayEntry!);
  }

  // Hide loading overlay
  static void hide() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }
}