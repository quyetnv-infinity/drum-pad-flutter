import 'package:cached_network_image/cached_network_image.dart';
import 'package:drumpad_flutter/config/ads_config.dart';
import 'package:drumpad_flutter/core/utils/locator_support.dart';
import 'package:drumpad_flutter/src/mvvm/models/lesson_model.dart';
import 'package:drumpad_flutter/src/service/api_service/api_service.dart';
import 'package:drumpad_flutter/src/widgets/overlay_loading/overlay_loading.dart';
import 'package:drumpad_flutter/src/widgets/unlock_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

void showDialogUnlockSongItem({required BuildContext context, required SongCollection item, required void Function() onTapGetPremium, required void Function() onTapWatchAds}){
  showDialog(context: context, builder: (context) => DialogUnlockSong(
      song: item,
      onTapGetPremium: onTapGetPremium,
      onTapWatchAds: onTapWatchAds,
    ),
  );
}

void showRequestRewardUnlockSongDialog({required BuildContext context, required void Function() onUserEarnedReward}){
  showDialog(
    context: context,
    builder: (BuildContext dialogContext) {
      return UnlockDialog(
        onConfirm: () {
          Navigator.pop(dialogContext);
          Navigator.pop(dialogContext);
          // showRewardAd(
          //   context: context,
          //   adId: "reward_choose_song",
          //   onUserEarnedReward: () async {
          //     print("onUserEarnedReward");
          //     OverlayLoading.show(context);
          //     onUserEarnedReward();
          //     OverlayLoading.hide();
          //   },
          // );
        },
        onCancel: () {
          Navigator.pop(dialogContext);
        },
      );
    },
  );
}

class DialogUnlockSong extends StatelessWidget {
  final SongCollection song;
  final void Function() onTapWatchAds;
  final void Function() onTapGetPremium;
  const DialogUnlockSong({super.key, required this.song, required this.onTapWatchAds, required this.onTapGetPremium});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 28),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            children: [
              ClipRRect(borderRadius: BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16)),
                  child: CachedNetworkImage(imageUrl: '${ApiService.BASEURL}${song.image}',
                    errorWidget: (context, url, error) => const Icon(Icons.image_not_supported_outlined),
                    fit: BoxFit.cover, width: MediaQuery.of(context).size.width - 56, height: MediaQuery.of(context).size.width - 56,)),
              Positioned(
                right: 10,
                top: 10,
                child: InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: SvgPicture.asset('assets/icons/ic_close.svg')))
            ],
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
                Color(0xFF141414), Color(0xFF5A2CE4)
              ], begin: Alignment.topLeft, end: Alignment.bottomRight),
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(16), bottomRight: Radius.circular(16))
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 8,),
                _buildButton(icon: 'assets/icons/ic_watch_ads.svg', title: context.locale.get_this_song_for_free, content: context.locale.watch_ad, onTap: onTapWatchAds),
                _buildButton(icon: 'assets/icons/ic_iap.svg', title: context.locale.unlock_all_song, content: context.locale.get_premium, onTap: onTapGetPremium),
                SizedBox(height: 8,)
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildButton({required String icon, required String title, required String content, required Function() onTap}){
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.7),
          borderRadius: BorderRadius.circular(12)
        ),
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          spacing: 16,
          children: [
            SvgPicture.asset(icon),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 2,
              children: [
                Text(title, style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700),),
                Text(content, style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500),),
              ],
            )
          ],
        ),
      ),
    );
  }
}
