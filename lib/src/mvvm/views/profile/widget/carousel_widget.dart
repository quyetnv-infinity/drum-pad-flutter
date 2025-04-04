import 'package:carousel_slider/carousel_slider.dart';
import 'package:drumpad_flutter/core/res/drawer/icon.dart';
import 'package:drumpad_flutter/core/res/drawer/image.dart';
import 'package:drumpad_flutter/core/utils/locator_support.dart';
import 'package:drumpad_flutter/src/mvvm/view_model/drum_learn_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class CarouselWidget extends StatelessWidget {
  const CarouselWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<DrumLearnProvider>();
    return Column(
      children: [
        CarouselSlider(
          items: [
            _buildCarouselItem(context, ResImage.imgCarouselBG1, ResIcon.icMusicProfile, (provider.beatRunnerSongComplete + provider.learnSongComplete).toString(), context.locale.song_completed),
            _buildCarouselItem(context, ResImage.imgCarouselBG2, ResIcon.icStarProfile, '17', context.locale.star_collected),
            _buildCarouselItem(context, ResImage.imgCarouselBG2, ResIcon.icAccuracyProfile, '17', context.locale.average_accuracy),
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
        ),
        _buildListCate(context, provider.beatRunnerSongComplete.toString()),
        _buildListCate(context, provider.learnSongComplete.toString()),
      ],
    );
  }

  Widget _buildCarouselItem(BuildContext context, String assetBg, String assetIcon, String info, String description){
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16),
      margin: EdgeInsets.symmetric(horizontal: 4),
      height: MediaQuery.sizeOf(context).width * 0.7,
      width: MediaQuery.sizeOf(context).width * 0.58,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        image: DecorationImage(image: AssetImage(assetBg), fit: BoxFit.cover)
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SvgPicture.asset(assetIcon),
          Text(info, textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 66, fontWeight: FontWeight.w700 ),),
          Flexible(child: Text(description, maxLines: 2, textAlign: TextAlign.center, overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700 ),)),
        ],
      ),
    );
  }

  Widget _buildListCate(BuildContext context, String itemCount){
    return Padding(
      padding: const EdgeInsets.only(left: 40, right: 40, top: 20),
      child: Column(
        children: [
          Row(
            spacing: 8,
            children: [
              Text(context.locale.beat_runner, maxLines: 1, textAlign: TextAlign.center, overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.white, fontSize: 23, fontWeight: FontWeight.w500 ),),
              Spacer(),
              Text(itemCount, maxLines: 1, textAlign: TextAlign.center, overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.white, fontSize: 23, fontWeight: FontWeight.w500 ),),
              SvgPicture.asset(ResIcon.icMusicProfile, height: 16,)
            ],
          )
        ],
      ),
    );
  }
}
