import 'package:carousel_slider/carousel_slider.dart';
import 'package:drumpad_flutter/core/res/drawer/image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CarouselWidget extends StatelessWidget {
  const CarouselWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CarouselSlider(
          items: [
            // _buildCarouselItem(context, ResImage.imgCarouselBG1),
            // _buildCarouselItem(context, ResImage.imgCarouselBG1),
            // _buildCarouselItem(context, ResImage.imgCarouselBG1),
          ],
          options: CarouselOptions(
            enableInfiniteScroll: false,
            height: MediaQuery.sizeOf(context).width * 0.7,
            initialPage: 0,
            autoPlay: false,
            enlargeCenterPage: true,
            enlargeFactor: 0.3,
            viewportFraction: 0.54,
          ),
        )
      ],
    );
  }
  Widget _buildCarouselItem(BuildContext context, String assetBg, String assetIcon, String info, String description){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4),
      height: MediaQuery.sizeOf(context).width * 0.7,
      width: MediaQuery.sizeOf(context).width * 0.58,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        image: DecorationImage(image: AssetImage(assetBg), fit: BoxFit.cover)
      ),
      child: Column(
        children: [
          SvgPicture.asset(assetIcon),
          Text(info, textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 66, fontWeight: FontWeight.w700 ),),
          Text(description, maxLines: 2, textAlign: TextAlign.center, overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700 ),),
        ],
      ),
    );
  }
}
