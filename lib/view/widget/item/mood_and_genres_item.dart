import 'package:and_drum_pad_flutter/data/model/category_model.dart';
import 'package:and_drum_pad_flutter/data/service/api_service/api_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class MoodAndGenresItem extends StatelessWidget {
  final Category category;
  const MoodAndGenresItem({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    final screenW = MediaQuery.sizeOf(context).width;
    return Container(
      height: screenW * 0.3,
      width: screenW * 0.45,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white.withValues(alpha: 0.3),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          CachedNetworkImage(
            ///*NOTE: CHANGE TO IMAGE
            imageUrl: '${ApiService.BASEURL}${category.name}',
            fit: BoxFit.cover,
          ),
          Positioned(
            top: 12,
            left: 12,
            child: Text(category.name, style: TextStyle(fontWeight: FontWeight.w600, color: Colors.black),)
          )
        ],
      ),
    );
  }
}
