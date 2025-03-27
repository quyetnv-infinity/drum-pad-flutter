import 'dart:ui';

import 'package:drumpad_flutter/src/mvvm/models/lesson_model.dart';
import 'package:flutter/material.dart';

class HorizontalList extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(
          data.length,
          (index) {
            SongCollection item = data[index];
            return Padding(
              padding: EdgeInsets.only(
                  left: index == 0 ? 16 : 0,
                  right: index == data.length - 1 ? 16 : 12),
              child: InkWell(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onTap: () => onTap(item, index),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: width,
                      height: height,
                      alignment: Alignment.topLeft,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        image: DecorationImage(
                          image: AssetImage(item.image!),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: !isShowDifficult
                          ? SizedBox.shrink()
                          : Container(
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
                                      item.difficulty.toUpperCase(),
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
                            ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      "${item.name}",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      "${item.author}",
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
          },
        ),
      ),
    );
  }
}
