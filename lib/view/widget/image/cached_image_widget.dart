import 'package:flutter/material.dart';

class CachedImageWidget extends StatelessWidget {
  final String imagePath;
  final double? width;
  final double? height;
  final BoxFit fit;
  final FilterQuality filterQuality;
  final int? cacheWidth;
  final int? cacheHeight;

  const CachedImageWidget({
    super.key,
    required this.imagePath,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.filterQuality = FilterQuality.medium,
    this.cacheWidth,
    this.cacheHeight,
  });

  // Cache static cho các ảnh được sử dụng nhiều lần
  static final Map<String, Widget> _imageCache = {};

  @override
  Widget build(BuildContext context) {
    final cacheKey = '$imagePath-$width-$height-${fit.toString()}';
    
    // Kiểm tra cache trước
    if (_imageCache.containsKey(cacheKey)) {
      return _imageCache[cacheKey]!;
    }

    // Tạo widget mới và cache lại
    final imageWidget = Image.asset(
      imagePath,
      width: width,
      height: height,
      fit: fit,
      cacheWidth: cacheWidth,
      cacheHeight: cacheHeight,
      filterQuality: filterQuality,
      // Thêm error builder để tránh crash khi ảnh không tồn tại
      errorBuilder: (context, error, stackTrace) {
        return Container(
          width: width,
          height: height,
          color: Colors.grey.withOpacity(0.3),
          child: const Icon(
            Icons.image_not_supported,
            color: Colors.grey,
          ),
        );
      },
    );

    // Cache widget (giới hạn cache để tránh memory leak)
    if (_imageCache.length < 50) {
      _imageCache[cacheKey] = imageWidget;
    }

    return imageWidget;
  }

  // Method để clear cache khi cần thiết
  static void clearCache() {
    _imageCache.clear();
  }

  // Method để remove ảnh cụ thể khỏi cache
  static void removeFromCache(String imagePath) {
    _imageCache.removeWhere((key, value) => key.startsWith(imagePath));
  }
}
