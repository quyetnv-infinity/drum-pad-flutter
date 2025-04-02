import 'dart:convert';

import 'package:drumpad_flutter/core/res/drawer/icon.dart';
import 'package:drumpad_flutter/core/res/drawer/image.dart';
import 'package:drumpad_flutter/core/res/style/text_style.dart';
import 'package:drumpad_flutter/core/utils/locator_support.dart';
import 'package:drumpad_flutter/src/mvvm/models/lesson_model.dart';
import 'package:drumpad_flutter/src/mvvm/view_model/drum_learn_provider.dart';
import 'package:drumpad_flutter/src/mvvm/views/drum_learn/game_play_screen.dart';
import 'package:drumpad_flutter/src/widgets/scaffold/custom_scaffold.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class LessonsScreen extends StatefulWidget {
  final SongCollection songCollection;
  const LessonsScreen({super.key, required this.songCollection});

  @override
  State<LessonsScreen> createState() => _LessonsScreenState();
}

class _LessonsScreenState extends State<LessonsScreen> {
  final ScrollController _scrollController = ScrollController();
  late SongCollection _song;
  bool isLoading = false;

  List<LessonSequence> displayData = [];

  @override
  void initState() {
    super.initState();
    fetchLessonData();
  }

  Future<void> fetchLessonData() async {
    setState(() {
      isLoading = true;
    });
    try {
      final drumLearnProvider = Provider.of<DrumLearnProvider>(context, listen: false);
      final songCollection = await drumLearnProvider.getSong(widget.songCollection.id);

      // Bây giờ bạn có thể sử dụng songCollection.lessons để truy cập vào các bài học
      print("Số lượng bài học: ${songCollection.lessons.length}");

      // Ví dụ: in ra số lượng events trong bài học đầu tiên
      if (songCollection.lessons.isNotEmpty) {
        print("Số lượng events trong bài học đầu tiên: ${songCollection.lessons[0].events.length}");
      }

      setState(() {
        _song = songCollection;
        displayData = _song.lessons.reversed.toList();
      });
    } catch (e) {
      print('Error loading sequence data from file: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  String _getStarIcon(double star) {
    if (star == 0) {
      return ResIcon.icStar0;
    } else if (star == 0.5) {
      return ResIcon.icStar05;
    } else if (star == 1.0) {
      return ResIcon.icStar1;
    } else if (star == 1.5) {
      return ResIcon.icStar15;
    } else if (star == 2.0) {
      return ResIcon.icStar2;
    } else if (star == 2.5) {
      return ResIcon.icStar25;
    } else if (star == 3.0) {
      return ResIcon.icStar3;
    } else {
      return ResIcon.icStar0;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Constants for layouts
    const double itemSize = 120.0;
    const double verticalSpacing = 120.0;
    const double initialTopOffset = 120.0;
    const double lineVerticalOffset = 220.0;
    const double extraHeight = 200.0;

    final screenWidth = MediaQuery.of(context).size.width;
    final contentWidth = screenWidth / 1.5;
    final leftSidePosition = 0.0;
    final rightSidePosition = contentWidth - itemSize;

    // Line positioning constants
    final leftLineHorizontalPosition = screenWidth / 7;
    final rightLineHorizontalPosition = screenWidth / 3.5;
    final lineWidth = screenWidth - (screenWidth / 7) * 2;
    const lineHeight = 70.0;

    // Tính toán tổng chiều cao cần thiết cho tất cả các mục
    double totalHeight = displayData.length * verticalSpacing + extraHeight;

    return CustomScaffold(
      // backgroundType: BackgroundType.gradient,
      backgroundImage: ResImage.imgBackgroundScreen,
      backgroundFit: BoxFit.cover,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leadingWidth: 100,
        leading: InkWell(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onTap: () {
            Navigator.maybePop(context);
          },
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(width: 12),
              Icon(Icons.arrow_back_ios, size: 18),
              SizedBox(width: 4.0),
              Text(
                context.locale.back,
                style: TextStyle(fontSize: 17, fontWeight: AppFonts.regular),
              ),
            ],
          ),
        ),
        title: Text(
          context.locale.campaign,
          style: TextStyle(
            fontSize: 20,
            fontWeight: AppFonts.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: isLoading
        ? CupertinoActivityIndicator()
        : SingleChildScrollView(
          reverse: true,
          padding: EdgeInsets.zero,
          controller: _scrollController,
          child: Center(
            child: SizedBox(
              width: contentWidth,
              height: totalHeight,
              child: Stack(
                children: [
                  /// Đường nối giữa các level
                  ...List.generate(displayData.isNotEmpty ? displayData.length - 1 : 0, (index) {
                    final verticalPosition =
                        lineVerticalOffset + index * verticalSpacing;
                    final isEvenIndex = index % 2 == 0;
                    final svgPath = isEvenIndex
                        ? ResIcon.icLineLeft
                        : ResIcon.icLineRight;
                    final horizontalPosition = isEvenIndex
                        ? leftLineHorizontalPosition
                        : rightLineHorizontalPosition;

                    return Positioned(
                      top: verticalPosition,
                      left: horizontalPosition,
                      child: SvgPicture.asset(
                        svgPath,
                        width: lineWidth,
                        height: lineHeight,
                        fit: BoxFit.fill,
                      ),
                    );
                  }),

                  /// Các nút level
                  ...List.generate(
                    displayData.length,
                    (index) {
                      final item = displayData[index];
                      final verticalPosition =
                          initialTopOffset + index * verticalSpacing;
                      final horizontalPosition = index % 2 == 0
                          ? leftSidePosition
                          : rightSidePosition;

                      return Positioned(
                        top: verticalPosition,
                        left: horizontalPosition,
                        child: InkWell(
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onTap: () async {
                            // Navigator.push(context, CupertinoPageRoute(builder: (context) => ResultScreen(perfectScore: 20, goodScore: 30, earlyScore: 20, lateScore: 10, missScore: 1),));
                            if(item.isCompleted || index == displayData.length - 1) {
                              await Navigator.push(context, CupertinoPageRoute(
                                builder: (context) =>
                                    GamePlayScreen(songCollection: _song,
                                      index: displayData.length -
                                          (index + 1),),));
                              await fetchLessonData();
                            }
                          },
                          child: Container(
                            width: itemSize,
                            height: itemSize,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage( item.isCompleted || index == displayData.length - 1 ? ResImage.imgBgButtonStepLessonUnlock
                                    : ResImage.imgBgButtonStepLesson),
                              ),
                              shape: BoxShape.circle,
                            ),
                            child: item.isCompleted || index == displayData.length - 1
                                ? Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment:
                                        MainAxisAlignment.center,
                                    children: [
                                       Text(
                                        context.locale.level,
                                        style: TextStyle(
                                          fontWeight: AppFonts.semiBold,
                                          fontSize: 14,
                                          color: Colors.white,
                                        ),
                                      ),
                                      Text(
                                        "${displayData.length - index}",
                                        style: TextStyle(
                                          fontWeight: AppFonts.semiBold,
                                          fontSize: 36,
                                          color: Colors.white,
                                        ),
                                      ),
                                      SvgPicture.asset(
                                        _getStarIcon(item.star),
                                        width: 30,
                                        height: 30,
                                        fit: BoxFit.cover,
                                      ),
                                    ],
                                  )
                                : Center(
                                    child: SizedBox(
                                      width: 40,
                                      height: 40,
                                      child: SvgPicture.asset(
                                        ResIcon.icLock,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
