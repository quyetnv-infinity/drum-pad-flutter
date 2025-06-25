import 'package:and_drum_pad_flutter/core/res/drawer/icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class RatingStars extends StatelessWidget {
  final double value;
  final double smallStarWidth;
  final double smallStarHeight;
  final double bigStarWidth;
  final double bigStarHeight;
  final bool? isFlatStar;
  final double? paddingMiddle;
  /// Widget hiển thị đánh giá bằng hệ thống 3 sao
  /// [value]: Giá trị đánh giá (0-100)
  /// Sử dụng [RatingStars.custom] để tùy chỉnh kích thước
  const RatingStars({
    Key? key,
    required this.value,
    this.isFlatStar = false,
  }) :
        smallStarWidth = 55.25,
        paddingMiddle = 0,
        smallStarHeight = 52,
        bigStarWidth = 93.5,
        bigStarHeight = 88,
        super(key: key);

  /// Constructor tùy chỉnh kích thước ngôi sao
  const RatingStars.custom({
    Key? key,
    required this.value,
    required this.smallStarWidth,
    required this.smallStarHeight,
    required this.bigStarWidth,
    required this.bigStarHeight,
  this.isFlatStar, this.paddingMiddle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final StarConfig leftStar = StarConfig.small(
      width: smallStarWidth,
      height: smallStarHeight,
      state: StarState.fromValue(
        value: value,
        nullThreshold: 15,
        fullThreshold: 45,
      ),
    );

    final StarConfig middleStar = StarConfig.big(
      width: bigStarWidth,
      height: bigStarHeight,
      isFlat: isFlatStar,
      paddingMiddle: paddingMiddle,
      state: StarState.fromValue(
        value: value,
        nullThreshold: 45,
        fullThreshold: 75,
      ),
    );

    final StarConfig rightStar = StarConfig.small(
      width: smallStarWidth,
      height: smallStarHeight,
      state: StarState.fromValue(
        value: value,
        nullThreshold: 75,
        fullThreshold: 100,
      ),
    );

    final StarConfig flatLeftStar = StarConfig.small(
      width: smallStarWidth,
      height: smallStarHeight,
      state: StarState.fromValue(
        value: value,
        nullThreshold: 15,
        fullThreshold: 45,
      ),
    );

    final StarConfig flatMiddleStar = StarConfig.big(
      width: smallStarWidth,
      height: smallStarWidth,
      state: StarState.fromValue(
        value: value,
        nullThreshold: 45,
        fullThreshold: 75,
      ),
    );

    final StarConfig flatRightStar = StarConfig.small(
      width: smallStarWidth,
      height: smallStarHeight,
      state: StarState.fromValue(
        value: value,
        nullThreshold: 75,
        fullThreshold: 100,
      ),
    );

    return isFlatStar! ? Row(
      spacing: 10,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: [
        leftStar.build(),
        middleStar.build(),
        rightStar.build(),
      ],
    ): Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: [
        flatLeftStar.build(),
        flatMiddleStar.build(),
        flatRightStar.build(),
      ],
    );
  }
}

/// Enum cho trạng thái ngôi sao
enum StarState {
  empty,
  full;

  /// Chuyển đổi từ giá trị số thành trạng thái sao
  static StarState fromValue({
    required double value,
    required double nullThreshold,
    required double fullThreshold,
  }) {
    if (value < nullThreshold) {
      return StarState.empty;
    } else if (value < fullThreshold) {
      return StarState.empty;
    } else {
      return StarState.full;
    }
  }

  /// Lấy đường dẫn asset tương ứng với trạng thái
  String get assetPath {
    switch (this) {
      case StarState.empty:
        return ResIcon.icStarNull;
      case StarState.full:
        return ResIcon.icStarFull;
    }
  }
}

/// Class cấu hình cho mỗi ngôi sao
class StarConfig {
  final double width;
  final double height;
  final StarState state;
  final bool? isFlat;
  final double? paddingMiddle;

  /// Constructor chính
  const StarConfig({
    required this.width,
    required this.height,
    required this.state,
    this.isFlat,
    this.paddingMiddle,
  });

  /// Constructor cho sao nhỏ
  factory StarConfig.small({
    required StarState state,
    required double width,
    required double height,
    double? paddingMiddle,
    bool? isFlat,
  }) {
    return StarConfig(
      state: state,
      width: width,
      height: height,
      paddingMiddle: paddingMiddle,
      isFlat: isFlat,
    );
  }

  /// Constructor cho sao lớn
  factory StarConfig.big({
    required StarState state,
    double? paddingMiddle,
    required double width,
    required double height,
    bool? isFlat,
  }) {
    return StarConfig(
      state: state,
      width: width,
      height: height,
      isFlat: isFlat,
      paddingMiddle: paddingMiddle,
    );
  }

  /// Tạo widget cho ngôi sao
  Widget build() {
    return Column(
      children: [
        SvgPicture.asset(
          state.assetPath,
          width: width,
          height: height,
        ),
        SizedBox(height: isFlat ?? false ? paddingMiddle : 0)
      ],
    );
  }
}

/// Cách sử dụng:
///
/// // Sử dụng kích thước mặc định
/// RatingStars(value: 65)
///
/// // Tùy chỉnh kích thước ngôi sao
/// RatingStars.custom(
///   value: 65,
///   smallStarWidth: 40,
///   smallStarHeight: 38,
///   bigStarWidth: 70,
///   bigStarHeight: 65,
/// )