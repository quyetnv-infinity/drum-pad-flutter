import 'package:flutter/material.dart';
// class SquareProgressPainter extends CustomPainter {
//   final double progress;
//   final Color color;
//   final double strokeWidth;
//   final double borderRadius;
//
//   SquareProgressPainter({
//     required this.progress,
//     this.color = Colors.white,
//     this.strokeWidth = 4.0,
//     this.borderRadius = 12.0,
//   });
//
//   @override
//   void paint(Canvas canvas, Size size) {
//     final Paint backgroundPaint = Paint()
//       ..color = color.withOpacity(0.2)
//       ..strokeWidth = strokeWidth
//       ..style = PaintingStyle.stroke;
//
//     final Paint foregroundPaint = Paint()
//       ..color = color
//       ..strokeWidth = strokeWidth
//       ..style = PaintingStyle.stroke
//       ..strokeCap = StrokeCap.square;
//
//     final rect = Rect.fromLTWH(
//       strokeWidth / 2,
//       strokeWidth / 2,
//       size.width - strokeWidth,
//       size.height - strokeWidth,
//     );
//
//     final rRect = RRect.fromRectAndRadius(rect, Radius.circular(borderRadius));
//
//     // Vẽ nền
//     canvas.drawRRect(rRect, backgroundPaint);
//
//     // Vẽ đường viền tiến độ (square path)
//     final path = Path()..addRRect(rRect);
//     final totalLength = path.computeMetrics().fold<double>(0, (sum, m) => sum + m.length);
//
//     final metric = path.computeMetrics().first;
//     final extractPath = metric.extractPath(0, totalLength * progress);
//     canvas.drawPath(extractPath, foregroundPaint);
//   }
//
//   @override
//   bool shouldRepaint(covariant SquareProgressPainter oldDelegate) =>
//       oldDelegate.progress != progress;
// }

class SquareProgressPainter extends CustomPainter {
  final double progress; // Vẫn là giá trị từ 0 → 1
  final Color color;
  final double strokeWidth;
  final double borderRadius;

  SquareProgressPainter({
    required this.progress,
    this.color = Colors.black,
    this.strokeWidth = 4.0,
    this.borderRadius = 12.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint backgroundPaint = Paint()
      ..color = color.withOpacity(0.2)
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final Paint foregroundPaint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.square;

    final rect = Rect.fromLTWH(
      strokeWidth / 2,
      strokeWidth / 2,
      size.width - strokeWidth,
      size.height - strokeWidth,
    );

    final rRect = RRect.fromRectAndRadius(rect, Radius.circular(borderRadius));

    // Vẽ nền
    canvas.drawRRect(rRect, backgroundPaint);

    // Vẽ đường viền giảm dần
    final path = Path()..addRRect(rRect);
    final totalLength = path.computeMetrics().fold<double>(0, (sum, m) => sum + m.length);

    final metric = path.computeMetrics().first;

    // Bắt đầu từ 0, nhưng dừng ở % còn lại (ví dụ progress = 0.8 thì vẽ 20%)
    final extractPath = metric.extractPath(0, totalLength * (1 - progress));
    canvas.drawPath(extractPath, foregroundPaint);
  }

  @override
  bool shouldRepaint(covariant SquareProgressPainter oldDelegate) =>
      oldDelegate.progress != progress;
}
