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

  /// Widget hiển thị đánh giá bằng hệ thống 3 sao
  /// [value]: Giá trị đánh giá (0-100)
  /// Sử dụng [RatingStars.custom] để tùy chỉnh kích thước
  const RatingStars({
    Key? key,
    required this.value,
    this.isFlatStar = false,
  }) :
        smallStarWidth = 55.25,
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
  this.isFlatStar,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final StarConfig leftStar = StarConfig.small(
      width: smallStarWidth,
      height: smallStarHeight,
      state: StarState.fromValue(
        value: value,
        nullThreshold: 15,
        halfThreshold: 30,
        fullThreshold: 45,
      ),
    );

    final StarConfig middleStar = StarConfig.big(
      width: bigStarWidth,
      height: bigStarHeight,
      state: StarState.fromValue(
        value: value,
        nullThreshold: 45,
        halfThreshold: 60,
        fullThreshold: 75,
      ),
    );

    final StarConfig rightStar = StarConfig.small(
      width: smallStarWidth,
      height: smallStarHeight,
      state: StarState.fromValue(
        value: value,
        nullThreshold: 75,
        halfThreshold: 90,
        fullThreshold: 100,
      ),
    );

    final StarConfig flatLeftStar = StarConfig.small(
      width: smallStarWidth,
      height: smallStarHeight,
      state: StarState.fromValue(
        value: value,
        nullThreshold: 15,
        halfThreshold: 30,
        fullThreshold: 45,
      ),
    );

    final StarConfig flatMiddleStar = StarConfig.big(
      width: smallStarWidth,
      height: smallStarWidth,
      state: StarState.fromValue(
        value: value,
        nullThreshold: 45,
        halfThreshold: 60,
        fullThreshold: 75,
      ),
    );

    final StarConfig flatRightStar = StarConfig.small(
      width: smallStarWidth,
      height: smallStarHeight,
      state: StarState.fromValue(
        value: value,
        nullThreshold: 75,
        halfThreshold: 90,
        fullThreshold: 100,
      ),
    );

    return isFlatStar! ? Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        leftStar.build(),
        middleStar.build(),
        rightStar.build(),
      ],
    ): Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
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
  half,
  full;

  /// Chuyển đổi từ giá trị số thành trạng thái sao
  static StarState fromValue({
    required double value,
    required double nullThreshold,
    required double halfThreshold,
    required double fullThreshold,
  }) {
    if (value < nullThreshold) {
      return StarState.empty;
    } else if (value < halfThreshold) {
      return StarState.half;
    } else if (value < fullThreshold) {
      return StarState.full;
    } else {
      return StarState.full;
    }
  }

  /// Lấy đường dẫn asset tương ứng với trạng thái
  String get assetPath {
    switch (this) {
      case StarState.empty:
        return ResIcon.icStarNull;
      case StarState.half:
        return ResIcon.icStarHalf;
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

  /// Constructor chung
  const StarConfig({
    required this.width,
    required this.height,
    required this.state,
  });

  /// Constructor cho sao nhỏ
  factory StarConfig.small({
    required StarState state,
    required double width,
    required double height,
  }) {
    return StarConfig(
      state: state,
      width: width,
      height: height,
    );
  }

  /// Constructor cho sao lớn
  factory StarConfig.big({
    required StarState state,
    required double width,
    required double height,
  }) {
    return StarConfig(
      state: state,
      width: width,
      height: height,
    );
  }

  /// Tạo widget cho ngôi sao
  Widget build() {
    return SvgPicture.asset(
      state.assetPath,
      width: width,
      height: height,
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