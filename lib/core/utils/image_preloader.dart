import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:and_drum_pad_flutter/core/res/drawer/image.dart';

/// Utility class để pre-cache các ảnh quan trọng
class ImagePreloader {
  static final List<String> _criticalImages = [
    ResImage.imgPads,
    ResImage.imgBG,
    ResImage.imgBackgroundScreen,
    ResImage.imgCampaign,
    ResImage.imgLearnFromSong,
    // Thêm các ảnh quan trọng khác
  ];

  /// Pre-load các ảnh quan trọng khi app khởi động
  static Future<void> preloadCriticalImages(BuildContext context) async {
    try {
      // Preload các ảnh quan trọng
      final futures = _criticalImages.map((imagePath) async {
        try {
          await precacheImage(AssetImage(imagePath), context);
          debugPrint('✓ Preloaded: $imagePath');
        } catch (e) {
          debugPrint('✗ Failed to preload: $imagePath - $e');
        }
      }).toList();

      await Future.wait(futures);
      debugPrint('🎉 All critical images preloaded successfully!');
    } catch (e) {
      debugPrint('❌ Error preloading images: $e');
    }
  }

  /// Pre-load ảnh cụ thể
  static Future<void> preloadImage(BuildContext context, String imagePath) async {
    try {
      await precacheImage(AssetImage(imagePath), context);
      debugPrint('✓ Preloaded: $imagePath');
    } catch (e) {
      debugPrint('✗ Failed to preload: $imagePath - $e');
    }
  }

  /// Pre-load nhiều ảnh cùng lúc
  static Future<void> preloadImages(BuildContext context, List<String> imagePaths) async {
    try {
      final futures = imagePaths.map((imagePath) => preloadImage(context, imagePath));
      await Future.wait(futures);
      debugPrint('🎉 Batch preload completed!');
    } catch (e) {
      debugPrint('❌ Error in batch preload: $e');
    }
  }

  /// Warm up Flutter's image cache
  static Future<void> warmUpImageCache() async {
    try {
      // Tăng kích thước cache
      PaintingBinding.instance.imageCache.maximumSize = 100;
      PaintingBinding.instance.imageCache.maximumSizeBytes = 20 << 20; // 20MB
      
      debugPrint('🔥 Image cache warmed up - Max size: ${PaintingBinding.instance.imageCache.maximumSize}');
      debugPrint('🔥 Image cache warmed up - Max bytes: ${PaintingBinding.instance.imageCache.maximumSizeBytes}');
    } catch (e) {
      debugPrint('❌ Error warming up image cache: $e');
    }
  }

  /// Clear image cache khi cần thiết
  static void clearImageCache() {
    PaintingBinding.instance.imageCache.clear();
    debugPrint('🧹 Image cache cleared');
  }

  /// Lấy thông tin cache hiện tại
  static void printCacheInfo() {
    final cache = PaintingBinding.instance.imageCache;
    debugPrint('📊 Image Cache Info:');
    debugPrint('   Current size: ${cache.currentSize}');
    debugPrint('   Current size bytes: ${cache.currentSizeBytes}');
    debugPrint('   Maximum size: ${cache.maximumSize}');
    debugPrint('   Maximum size bytes: ${cache.maximumSizeBytes}');
  }
}
