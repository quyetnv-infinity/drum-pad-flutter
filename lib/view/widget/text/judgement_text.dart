import 'package:and_drum_pad_flutter/core/res/style/text_style.dart';
import 'package:flutter/material.dart';

class JudgementText {
  JudgementText._();

  /// Widget để tạo văn bản với hiệu ứng gradient "Perfect" (màu hồng)
  static Widget perfect(
    String text, {
    double fontSize = 37,
    FontWeight fontWeight = FontWeight.w400,
    bool italic = true,
    bool underline = false,
    TextAlign? textAlign,
  }) {
    return ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback: (bounds) => LinearGradient(
        colors: [
          Color(0xFFFF0099), // Hồng đậm
          Color(0xFFFF7474), // Hồng nhạt
        ],
        begin: Alignment.centerRight,
        end: Alignment.centerLeft,
      ).createShader(bounds),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Text(
          text,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: fontSize,
            decoration: underline ? TextDecoration.underline : TextDecoration.none,
            fontWeight: fontWeight,
            fontFamily: AppFonts.shrikhandRegular,
            fontStyle: italic ? FontStyle.italic : FontStyle.normal,
          ),
          textAlign: textAlign,
        ),
      ),
    );
  }

  /// Widget để tạo văn bản với hiệu ứng gradient "Good" (màu cam)
  static Widget good(
    String text, {
    double fontSize = 37,
    FontWeight fontWeight = FontWeight.w400,
    bool italic = true,
    bool underline = false,
    TextAlign? textAlign,
  }) {
    return ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback: (bounds) => LinearGradient(
        colors: [
          Color(0xFFFFFB00), // Cam nhạt
          Color(0xFFFFA600), // Cam đậm
        ],
        begin: Alignment.centerRight,
        end: Alignment.centerLeft,
      ).createShader(bounds),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Text(
          text,
          style: TextStyle(
            decoration: underline ? TextDecoration.underline : TextDecoration.none,
            fontSize: fontSize,
            fontWeight: fontWeight,
            fontFamily: AppFonts.shrikhandRegular,
            fontStyle: italic ? FontStyle.italic : FontStyle.normal,
          ),
          textAlign: textAlign,
        ),
      ),
    );
  }

  /// Widget để tạo văn bản với hiệu ứng gradient "Early" (màu xanh lá)
  static Widget early(
    String text, {
    double fontSize = 37,
    FontWeight fontWeight = FontWeight.w400,
    bool italic = true,
    bool underline = false,
    TextAlign? textAlign,
  }) {
    return ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback: (bounds) => LinearGradient(
        colors: [
          Color(0xFF00FF37),
          Color(0xFFB9FF74),
        ],
        begin: Alignment.centerRight,
        end: Alignment.centerLeft,
      ).createShader(bounds),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Text(
          text,
          style: TextStyle(
            fontSize: fontSize,
            decoration: underline ? TextDecoration.underline : TextDecoration.none,
            fontWeight: fontWeight,
            fontFamily: AppFonts.shrikhandRegular,
            fontStyle: italic ? FontStyle.italic : FontStyle.normal,
          ),
          textAlign: textAlign,
        ),
      ),
    );
  }

  /// Widget để tạo văn bản với hiệu ứng gradient "Late" (màu xanh dương)
  static Widget late(
    String text, {
    double fontSize = 37,
    FontWeight fontWeight = FontWeight.w400,
    bool italic = true,
    bool underline = false,
    TextAlign? textAlign,
  }) {
    return ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback: (bounds) => LinearGradient(
        colors: [
          Color(0xFF00FFE0),
          Color(0xFF00A3FF),
        ],
        begin: Alignment.centerRight,
        end: Alignment.centerLeft,
      ).createShader(bounds),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Text(
          text,
          style: TextStyle(
            fontSize: fontSize,
            decoration: underline ? TextDecoration.underline : TextDecoration.none,
            fontWeight: fontWeight,
            fontFamily: AppFonts.shrikhandRegular,
            fontStyle: italic ? FontStyle.italic : FontStyle.normal,
          ),
          textAlign: textAlign,
        ),
      ),
    );
  }

  /// Widget để tạo văn bản với hiệu ứng gradient "Miss" (màu xám)
  static Widget miss(
    String text, {
    double fontSize = 37,
    FontWeight fontWeight = FontWeight.w400,
    bool italic = true,
    bool underline = false,
    TextAlign? textAlign,
  }) {
    return ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback: (bounds) => LinearGradient(
        colors: [
          Colors.white,
          Color(0xFF999999),
        ],
        begin: Alignment.centerRight,
        end: Alignment.centerLeft,
      ).createShader(bounds),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Text(
          text,
          style: TextStyle(
            fontSize: fontSize,
            decoration: underline ? TextDecoration.underline : TextDecoration.none,
            fontWeight: fontWeight,
            fontFamily: AppFonts.shrikhandRegular,
            fontStyle: italic ? FontStyle.italic : FontStyle.normal,
          ),
          textAlign: textAlign,
        ),
      ),
    );
  }

  /// Phương thức tổng hợp để tạo văn bản dựa trên loại đánh giá
  static Widget byRating(
    String text, {
    required RatingType rating,
    double fontSize = 37,
    FontWeight fontWeight = FontWeight.w400,
    bool italic = true,
    TextAlign? textAlign,
  }) {
    switch (rating) {
      case RatingType.perfect:
        return perfect(text,
            fontSize: fontSize,
            fontWeight: fontWeight,
            italic: italic,
            textAlign: textAlign);
      case RatingType.good:
        return good(text,
            fontSize: fontSize,
            fontWeight: fontWeight,
            italic: italic,
            textAlign: textAlign);
      case RatingType.early:
        return early(text,
            fontSize: fontSize,
            fontWeight: fontWeight,
            italic: italic,
            textAlign: textAlign);
      case RatingType.late:
        return late(text,
            fontSize: fontSize,
            fontWeight: fontWeight,
            italic: italic,
            textAlign: textAlign);
      case RatingType.miss:
        return miss(text,
            fontSize: fontSize,
            fontWeight: fontWeight,
            italic: italic,
            textAlign: textAlign);
    }
  }

  /// Widget có hiệu ứng text với viền ngoài
  static Widget withStroke(
    String text, {
    required Color textColor,
    required Color strokeColor,
    double strokeWidth = 2.0,
    double fontSize = 37,
    FontWeight fontWeight = FontWeight.w400,
    bool italic = false,
    TextAlign? textAlign,
  }) {
    return Stack(
      children: [
        // Viền stroke
        Text(
          text,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: fontWeight,
            fontStyle: italic ? FontStyle.italic : FontStyle.normal,
            foreground: Paint()
              ..style = PaintingStyle.stroke
              ..strokeWidth = strokeWidth
              ..color = strokeColor,
          ),
          textAlign: textAlign,
        ),
        // Text chính
        Text(
          text,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: fontWeight,
            fontStyle: italic ? FontStyle.italic : FontStyle.normal,
            color: textColor,
          ),
          textAlign: textAlign,
        ),
      ],
    );
  }
}

/// Enum định nghĩa các loại đánh giá
enum RatingType {
  perfect,
  good,
  early,
  late,
  miss,
}

/// Sử dụng các widget trong ứng dụng:
///
/// ```dart
/// JudgementText.perfect('Perfect', fontSize: 32)
/// JudgementText.good('Good', fontSize: 28)
/// JudgementText.early('Early', fontSize: 28)
/// JudgementText.late('Late', fontSize: 28)
/// JudgementText.miss('Miss', fontSize: 28)
///
/// // Hoặc sử dụng phương thức byRating
/// JudgementText.byRating('Perfect', rating: RatingType.perfect, fontSize: 32)
/// ```
