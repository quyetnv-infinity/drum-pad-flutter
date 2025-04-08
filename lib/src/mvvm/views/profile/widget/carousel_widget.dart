import 'package:carousel_slider/carousel_slider.dart';
import 'package:drumpad_flutter/core/res/drawer/icon.dart';
import 'package:drumpad_flutter/core/res/drawer/image.dart';
import 'package:drumpad_flutter/core/utils/locator_support.dart';
import 'package:drumpad_flutter/src/mvvm/view_model/drum_learn_provider.dart';
import 'package:drumpad_flutter/src/mvvm/view_model/result_information_provider.dart';
import 'package:drumpad_flutter/src/widgets/text/judgement_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class CarouselWidget extends StatefulWidget {
  const CarouselWidget({super.key});

  @override
  State<CarouselWidget> createState() => _CarouselWidgetState();
}

class _CarouselWidgetState extends State<CarouselWidget> {

  @override
  void initState() {
    super.initState();
    final drumProvider = context.read<DrumLearnProvider>();
    final resultProvider = context.read<ResultInformationProvider>();
    drumProvider.getTotalStars();
    drumProvider.getBeatRunnerStars();
    drumProvider.getLearnSongComplete();
    drumProvider.getBeatRunnerSongComplete();
    drumProvider.getRandomSongs();

    resultProvider.loadPoints();
  }

  int indexCarouselItem = 0;

  double calculatePercent(int point, int totalPoint) {
    if (totalPoint == 0) return 0;
    final percent = (point / totalPoint) * 100;
    return percent.floorToDouble();
  }

  double calculateMissPercent(){
    final resultProvider = context.read<ResultInformationProvider>();
    if(resultProvider.totalPoint() == 0) return 0;
    return 100 - (
        calculatePercent(resultProvider.perfectPoint, resultProvider.totalPoint())+
        calculatePercent(resultProvider.goodPoint, resultProvider.totalPoint())+
        calculatePercent(resultProvider.earlyPoint, resultProvider.totalPoint())+
        calculatePercent(resultProvider.latePoint, resultProvider.totalPoint())
    );
  }

  @override
  Widget build(BuildContext context) {
    final resultProvider = context.read<ResultInformationProvider>();
    final perfectPercent = calculatePercent(resultProvider.perfectPoint, resultProvider.totalPoint());
    final goodPercent = calculatePercent(resultProvider.goodPoint, resultProvider.totalPoint());
    final provider = context.watch<DrumLearnProvider>();
    return Column(
      children: [
        CarouselSlider(
          items: [
            _buildCarouselItem(context, ResImage.imgCarouselBG1, ResIcon.icMusicProfile, (provider.beatRunnerSongComplete + provider.learnSongComplete).toString(), context.locale.song_completed),
            _buildCarouselItem(context, ResImage.imgCarouselBG2, ResIcon.icStarProfile, (provider.totalStar + provider.beatRunnerStar).toString(), context.locale.star_collected),
            _buildCarouselItem(context, ResImage.imgCarouselBG2, ResIcon.icAccuracyProfile, "${(perfectPercent + goodPercent).toInt().toString()}%", context.locale.average_accuracy),
          ],
          options: CarouselOptions(
            onPageChanged: (index, reason) {
              setState(() {
                indexCarouselItem = index;
              });
            },
            enableInfiniteScroll: false,
            height: MediaQuery.sizeOf(context).width * 0.7,
            initialPage: 0,
            autoPlay: false,
            enlargeCenterPage: true,
            enlargeFactor: 0.3,
            viewportFraction: 0.54,
          ),
        ),
        checkIndexCase()
      ],
    );
  }

  Widget checkIndexCase(){
    final provider = context.watch<DrumLearnProvider>();
    final resultProvider = context.read<ResultInformationProvider>();
    switch(indexCarouselItem){
      case 0: return Column(
        children: [
          _buildListCate(context, context.locale.beat_runner, provider.beatRunnerSongComplete.toString(), ResIcon.icMusicProfile),
          _buildListCate(context, context.locale.drum_learn, provider.learnSongComplete.toString(), ResIcon.icMusicProfile),
        ],);
      case 1: return Column(
        children: [
          _buildListCate(context,context.locale.beat_runner , provider.beatRunnerStar.toString(), ResIcon.icStarFull),
          _buildListCate(context,context.locale.drum_learn, provider.totalStar.toString(), ResIcon.icStarFull),
        ],);
      case 2:
        return Padding(
          padding: const EdgeInsets.only(top: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _rowScore(
                title: JudgementText.perfect(
                  context.locale.perfect,
                  textAlign: TextAlign.center,
                    fontSize: 25
                ),
                value: calculatePercent(resultProvider.perfectPoint, resultProvider.totalPoint()),
              ),
              _rowScore(
                title: JudgementText.good(
                  context.locale.good,
                  textAlign: TextAlign.center,
                  fontSize: 25
                ),
                value: calculatePercent(resultProvider.goodPoint, resultProvider.totalPoint()),
              ),
              _rowScore(
                title: JudgementText.early(
                  context.locale.early,
                  textAlign: TextAlign.center,
                    fontSize: 25
                ),
                value: calculatePercent(resultProvider.earlyPoint, resultProvider.totalPoint()),
              ),
              _rowScore(
                title: JudgementText.late(
                  context.locale.late,
                  textAlign: TextAlign.center,
                    fontSize: 25
                ),
                value: calculatePercent(resultProvider.latePoint, resultProvider.totalPoint()),
              ),
              _rowScore(
                title: JudgementText.miss(
                  context.locale.miss,
                  textAlign: TextAlign.center,
                    fontSize: 25
                ),
                value: calculateMissPercent(),
              ),
            ],
          ),
        );
      default:
    return const SizedBox();
    }
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

  Widget _buildListCate(BuildContext context,String title, String itemCount, String iconAsset){
    return Padding(
      padding: const EdgeInsets.only(left: 40, right: 40, top: 20),
      child: Column(
        children: [
          Row(
            spacing: 8,
            children: [
              Text(title, maxLines: 1, textAlign: TextAlign.center, overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.white, fontSize: 23, fontWeight: FontWeight.w500 ),),
              Spacer(),
              Text(itemCount, maxLines: 1, textAlign: TextAlign.center, overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.white, fontSize: 23, fontWeight: FontWeight.w500 ),),
              SvgPicture.asset(iconAsset, height: 16,)
            ],
          )
        ],
      ),
    );
  }

  Widget _rowScore(
      {required Widget title, double value = 0}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50.0),
      child: Row(
        children: [
          Expanded(flex: 2, child: title),
          Expanded(
            flex: 1,
            child: Text(
              "${value.toStringAsFixed(0)}%",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
