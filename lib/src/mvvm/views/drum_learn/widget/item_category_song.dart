import 'package:cached_network_image/cached_network_image.dart';
import 'package:drumpad_flutter/core/res/drawer/image.dart';
import 'package:drumpad_flutter/src/mvvm/models/lesson_model.dart';
import 'package:drumpad_flutter/src/service/api_service/api_service.dart';
import 'package:drumpad_flutter/src/widgets/blur_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ItemCategorySong extends StatefulWidget {
  final SongCollection model;
  final bool isUnlocked;
  const ItemCategorySong({super.key, required this.model, required this.isUnlocked});

  @override
  State<ItemCategorySong> createState() => _ItemCategorySongState();
}

class _ItemCategorySongState extends State<ItemCategorySong> {
  bool isErrorLoading = false;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).width * 0.17;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Row(
        spacing: 12,
        children: [
          Container(
            height: height,
            width: height,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              image: DecorationImage(image: isErrorLoading?
              AssetImage(ResImage.imgBackgoundScreen) :
              CachedNetworkImageProvider('${ApiService.BASEURL}${widget.model.image}'),
                onError: (exception, stackTrace) {
                  setState(() {
                    isErrorLoading = true;
                  });
                },
                fit: BoxFit.cover)
            ),
            child: !widget.isUnlocked ? Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                gradient: LinearGradient(colors: [
                  Color(0xFF5936C2).withValues(alpha: 0.7), Color(0xFF150C31).withValues(alpha: 0.7)
                ], begin: Alignment.topCenter, end: Alignment.bottomCenter)
              ),
              child: SvgPicture.asset('assets/icons/ic_lock.svg', width: height * 0.5,),
            ) : SizedBox.shrink()
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 4,
              children: [
                Text(widget.model.name ?? '', maxLines: 1,overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w600)),
                Text(widget.model.author ?? "Null", style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w400)),
                IntrinsicWidth(
                  child: BlurWidget(text: widget.model.difficulty,)),
              ],
            ),
          )
        ],
      ),
    );
  }
}
