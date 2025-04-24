import 'package:drumpad_flutter/core/res/drawer/image.dart';
import 'package:drumpad_flutter/core/utils/locator_support.dart';
import 'package:drumpad_flutter/src/mvvm/models/lesson_model.dart';
import 'package:drumpad_flutter/src/mvvm/view_model/campaign_provider.dart';
import 'package:drumpad_flutter/src/mvvm/view_model/purchase_provider.dart';
import 'package:drumpad_flutter/src/mvvm/views/iap/iap_screen.dart';
import 'package:drumpad_flutter/src/mvvm/views/mode_campaign/mode_campaign_screen.dart';
import 'package:drumpad_flutter/src/widgets/blur_widget.dart';
import 'package:drumpad_flutter/src/widgets/star/star_result.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class CampaignItem extends StatefulWidget {
  final String difficult;
  const CampaignItem({super.key, required this.difficult});

  @override
  State<CampaignItem> createState() => _CampaignItemState();
}

class _CampaignItemState extends State<CampaignItem> {
  int _percent = 0;
  double _star = 0;
  List<SongCollection> _listCampaign = [];

  @override
  void initState() {
    super.initState();
    final campaignProvider = Provider.of<CampaignProvider>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      setPercent(campaignProvider);
    },);
  }

  Future<void> setPercent(CampaignProvider campaignProvider) async {
    switch(widget.difficult){
      case DifficultyMode.easy:
        await campaignProvider.fetchCampaignSong(isEasy: true);
        setState(() {
          _listCampaign = campaignProvider.easyCampaign;
          _percent = campaignProvider.easyCampaign.isNotEmpty ? ((campaignProvider.easyUnlocked / campaignProvider.easyCampaign.length) * 100).floor() : 0;
        });
        break;
      case DifficultyMode.medium:
        await campaignProvider.fetchCampaignSong(isMedium: true);
        setState(() {
          _listCampaign = campaignProvider.mediumCampaign;
          _percent = campaignProvider.mediumCampaign.isNotEmpty ?  ((campaignProvider.mediumUnlocked / campaignProvider.mediumCampaign.length) * 100).floor() : 0;
        });
        break;
      case DifficultyMode.hard:
        await campaignProvider.fetchCampaignSong(isHard: true);
        setState(() {
          _listCampaign = campaignProvider.hardCampaign;
          _percent = campaignProvider.hardCampaign.isNotEmpty ? ((campaignProvider.hardUnlocked / campaignProvider.hardCampaign.length) * 100).floor() : 0;
        });
        break;
      case DifficultyMode.demonic:
        await campaignProvider.fetchCampaignSong(isDemonic: true);
        setState(() {
          _listCampaign = campaignProvider.demonicCampaign;
          _percent = campaignProvider.demonicCampaign.isNotEmpty ? ((campaignProvider.demonicUnlocked / campaignProvider.demonicCampaign.length) * 100).floor() : 0;
        });
        break;
    }
    setState(() {
      _percent = _percent > 100 ? 100 : _percent;
    });
    fetchStarAverage();
  }

  void fetchStarAverage(){
    int count = 0;
    double starSum = 0;
    if(_listCampaign.isEmpty){
      setState(() {
        _star = 0;
      });
      return;
    }
    for(var i = 0; i < _listCampaign.length; i++){
      if(i == 0 || _listCampaign[i].campaignStar != 0) {
        count++;
        starSum += _listCampaign[i].campaignStar;
      }
    }
    setState(() {
      _star = (starSum/count) * (100/3);
    });
  }

  int getUnlockedIndex(CampaignProvider campaignProvider){
    switch(widget.difficult){
      case DifficultyMode.easy:
        return campaignProvider.easyUnlocked;
      case DifficultyMode.medium:
        return campaignProvider.mediumUnlocked;
      case DifficultyMode.hard:
        return campaignProvider.hardUnlocked;
      case DifficultyMode.demonic:
        return campaignProvider.demonicUnlocked;
      default: return 0;
    }
  }

  bool get isEasy => widget.difficult == DifficultyMode.easy;
  bool get isMedium => widget.difficult == DifficultyMode.medium;
  bool get isHard => widget.difficult == DifficultyMode.hard;
  bool get isDemonic => widget.difficult == DifficultyMode.demonic;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context).width;
    return Consumer2<CampaignProvider, PurchaseProvider>(
      builder: (context, provider, purchaseProvider, _) {
        bool isUnlocked = widget.difficult == DifficultyMode.easy || purchaseProvider.isSubscribed;
        return GestureDetector(
          onTap: () async {
            if(isUnlocked) {
              provider.setCurrentCampaign(isEasy: isEasy,
                  isMedium: isMedium,
                  isHard: isHard,
                  isDemonic: isDemonic);
              await Navigator.push(context, CupertinoPageRoute(
                builder: (context) =>
                    ModeCampaignScreen(difficult: widget.difficult,
                      listCampaignSong: _listCampaign,),));
              await setPercent(provider);
            } else {
              Navigator.push(context, CupertinoPageRoute(builder: (context) => IapScreen(),));
            }
          },
          child: Stack(
            children: [
              Container(
                height: size * 0.4,
                margin: EdgeInsets.symmetric(vertical: 16),
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  image: DecorationImage(image: AssetImage(ResImage.imgCampaignBG), fit: BoxFit.cover)
                ),
                child: Row(
                  spacing: 16,
                  // mainAxisSize: MainAxisSize.max,
                  children: [
                    Image.asset(ResImage.imgPad),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        BlurWidget(text: DifficultyMode.getString(context, widget.difficult).toUpperCase(),),
                        Text(isEasy ? '${context.locale.fundamental} 1' : (isMedium ? '${context.locale.fundamental} 2' : (isHard ? '${context.locale.follow_da_beat} 1' : '${context.locale.follow_da_beat} 2')), style: TextStyle(fontSize: 23, fontWeight: FontWeight.w600, color:  Colors.white)),
                        Text('${context.locale.progress}: $_percent%', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color:  Colors.white)),
                        RatingStars.custom(value: _star, smallStarWidth: 20, smallStarHeight: 20, bigStarWidth: 20, bigStarHeight: 20, isFlatStar: true,)
                      ],
                    )
                  ],
                ),
              ),
              if(!isUnlocked)
                Container(
                  height: size * 0.4,
                  width: double.infinity,
                  margin: EdgeInsets.symmetric(vertical: 16),
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    gradient: LinearGradient(colors: [
                      Color(0xFF5936C2).withValues(alpha: 0.7), Color(0xFF150C31).withValues(alpha: 0.7)
                    ], begin: Alignment.topCenter, end: Alignment.bottomCenter)
                  ),
                  alignment: Alignment.center,
                  child: SvgPicture.asset('assets/icons/ic_lock.svg', width: 52, height: 52,),
                )
            ],
          ),
        );
      }
    );
  }
}
