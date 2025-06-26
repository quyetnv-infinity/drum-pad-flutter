import 'package:flutter/material.dart';

/// Mixin để tối ưu hóa việc rebuild widget
/// Sử dụng cho các widget có thể được rebuild nhiều lần
mixin OptimizedWidgetMixin<T extends StatelessWidget> on StatelessWidget {
  
  /// Cache các TextStyle để tránh tạo mới mỗi lần build
  static final Map<String, TextStyle> _textStyleCache = {};
  
  /// Cache các BorderRadius để tránh tạo mới mỗi lần build
  static final Map<double, BorderRadius> _borderRadiusCache = {};
  
  /// Cache các EdgeInsets để tránh tạo mới mỗi lần build
  static final Map<String, EdgeInsets> _edgeInsetsCache = {};

  /// Lấy TextStyle từ cache hoặc tạo mới
  TextStyle getCachedTextStyle({
    double? fontSize,
    FontWeight? fontWeight,
    Color? color,
    double? height,
    String? fontFamily,
  }) {
    final key = '$fontSize-$fontWeight-$color-$height-$fontFamily';
    
    return _textStyleCache[key] ??= TextStyle(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      height: height,
      fontFamily: fontFamily,
    );
  }

  /// Lấy BorderRadius từ cache hoặc tạo mới
  BorderRadius getCachedBorderRadius(double radius) {
    return _borderRadiusCache[radius] ??= BorderRadius.circular(radius);
  }

  /// Lấy EdgeInsets từ cache hoặc tạo mới
  EdgeInsets getCachedEdgeInsets({
    double? all,
    double? horizontal,
    double? vertical,
    double? left,
    double? top,
    double? right,
    double? bottom,
  }) {
    final key = '$all-$horizontal-$vertical-$left-$top-$right-$bottom';
    
    if (_edgeInsetsCache.containsKey(key)) {
      return _edgeInsetsCache[key]!;
    }

    EdgeInsets insets;
    if (all != null) {
      insets = EdgeInsets.all(all);
    } else if (horizontal != null || vertical != null) {
      insets = EdgeInsets.symmetric(
        horizontal: horizontal ?? 0,
        vertical: vertical ?? 0,
      );
    } else {
      insets = EdgeInsets.only(
        left: left ?? 0,
        top: top ?? 0,
        right: right ?? 0,
        bottom: bottom ?? 0,
      );
    }

    return _edgeInsetsCache[key] = insets;
  }

  /// Clear cache khi cần thiết
  static void clearStyleCache() {
    _textStyleCache.clear();
    _borderRadiusCache.clear();
    _edgeInsetsCache.clear();
  }
}

/// Extension để tối ưu hóa việc tạo const widget
extension ConstWidgetExtension on Widget {
  /// Wrap widget trong RepaintBoundary để tránh repaint không cần thiết
  Widget get optimized => RepaintBoundary(child: this);
  
  /// Wrap widget trong AutomaticKeepAliveClientMixin context
  Widget get keepAlive => _KeepAliveWrapper(child: this);
}

class _KeepAliveWrapper extends StatefulWidget {
  final Widget child;
  
  const _KeepAliveWrapper({required this.child});

  @override
  State<_KeepAliveWrapper> createState() => _KeepAliveWrapperState();
}

class _KeepAliveWrapperState extends State<_KeepAliveWrapper> 
    with AutomaticKeepAliveClientMixin {
  
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.child;
  }
}
