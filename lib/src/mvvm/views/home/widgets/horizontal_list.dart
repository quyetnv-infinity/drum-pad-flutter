import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:drumpad_flutter/core/res/drawer/image.dart';
import 'package:drumpad_flutter/core/utils/dialog_unlock_song.dart';
import 'package:drumpad_flutter/src/mvvm/models/lesson_model.dart';
import 'package:drumpad_flutter/src/mvvm/view_model/purchase_provider.dart';
import 'package:drumpad_flutter/src/mvvm/view_model/unlock_provider.dart';
import 'package:drumpad_flutter/src/mvvm/views/home/widgets/marquee_text.dart';
import 'package:drumpad_flutter/src/mvvm/views/iap/iap_screen.dart';
import 'package:drumpad_flutter/src/service/api_service/api_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class HorizontalList extends StatefulWidget {
  final double width;
  final double height;
  final bool isShowDifficult;
  final List<SongCollection> data;
  final Function(SongCollection item, int index) onTap;

  const HorizontalList(
      {super.key,
      required this.width,
      required this.height,
      this.isShowDifficult = false,
      required this.data,
      required this.onTap});

  @override
  State<HorizontalList> createState() => _HorizontalListState();
}

class _HorizontalListState extends State<HorizontalList> {
  bool isErrorLoading = false;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(
          widget.data.length,
          (index) {
            SongCollection item = widget.data[index];
            return Padding(
              padding: EdgeInsets.only(
                  left: index == 0 ? 16 : 0,
                  right: index == widget.data.length - 1 ? 16 : 12),
              child: Consumer<PurchaseProvider>(
                builder: (context, purchaseProvider, _) {
                  bool songUnlock = context.watch<UnlockedSongsProvider>().isSongUnlocked(item.id);
                  bool isUnlocked = songUnlock || purchaseProvider.isSubscribed;
                  return InkWell(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onTap: () {
                      if(!isUnlocked) {
                        showDialogUnlockSongItem(
                          context: context,
                          item: item,
                          onTapGetPremium: () {
                            Navigator.pop(context);
                            Navigator.push(context, CupertinoPageRoute(builder: (context) => IapScreen(),));
                          },
                          onTapWatchAds: () {
                            showRequestRewardUnlockSongDialog(context: context, onUserEarnedReward: () {
                              context.read<UnlockedSongsProvider>().unlockSong(item.id);
                              widget.onTap(item, index);
                            },);
                          },
                        );
                      } else {
                        widget.onTap(item, index);
                      }
                    },
                    child: SizedBox(
                      width: widget.width,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Stack(
                            children: [
                              Container(
                                width: widget.width,
                                height: widget.height,
                                alignment: Alignment.topLeft,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                    image: DecorationImage(image: isErrorLoading?
                                    AssetImage(ResImage.imgBackgoundScreen) :
                                    CachedNetworkImageProvider('${ApiService.BASEURL}${item.image}'),
                                      onError: (exception, stackTrace) {
                                        setState(() {
                                          isErrorLoading = true;
                                        });
                                      },
                                      fit: BoxFit.cover)
                                ),
                                child: (widget.isShowDifficult && item.difficulty != DifficultyMode.unknown) ?
                                  Container(
                                    margin: EdgeInsets.all(10),
                                    child: ClipRRect(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(4)),
                                      child: BackdropFilter(
                                        filter:
                                            ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 8, vertical: 4),
                                          decoration: BoxDecoration(
                                            color:
                                                Colors.white.withValues(alpha: 0.5),
                                            // Background với overlay effect
                                            borderRadius:
                                                BorderRadius.all(Radius.circular(4)),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Color(0x30000000),
                                                blurRadius: 10,
                                                offset: Offset(0, 0),
                                              ),
                                            ],
                                          ),
                                          child: Text(
                                            DifficultyMode.getString(context, item.difficulty).toUpperCase(),
                                            style: TextStyle(
                                              color: Colors.black,
                                              shadows: [
                                                Shadow(
                                                  color: Colors.black
                                                      .withValues(alpha: 0.5),
                                                  blurRadius: 2,
                                                ),
                                              ],
                                              fontSize: 10,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ) : SizedBox.shrink(),
                              ),
                              if(!isUnlocked) Container(
                                width: widget.width,
                                height: widget.height,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  gradient: LinearGradient(colors: [
                                    Color(0xFF5936C2).withValues(alpha: 0.7), Color(0xFF150C31).withValues(alpha: 0.7)
                                  ], begin: Alignment.topCenter, end: Alignment.bottomCenter)
                                ),
                                child: SvgPicture.asset('assets/icons/ic_lock.svg'),
                              )
                            ],
                          ),
                          SizedBox(height: 4),
                          SizedBox(
                            width: widget.width,
                            height: 20,
                            child: MarqueeText(text: item.name, width: widget.width, style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              ),
                            )
                          ),
                          Text(
                            item.author,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }
              ),
            );
          },
        ),
      ),
    );
  }
}
