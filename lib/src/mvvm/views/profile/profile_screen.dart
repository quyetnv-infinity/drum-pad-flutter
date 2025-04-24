import 'package:drumpad_flutter/core/utils/locator_support.dart';
import 'package:drumpad_flutter/src/mvvm/models/lesson_model.dart';
import 'package:drumpad_flutter/src/mvvm/view_model/ads_provider.dart';
import 'package:drumpad_flutter/src/mvvm/view_model/drum_learn_provider.dart';
import 'package:drumpad_flutter/src/mvvm/views/home/widgets/horizontal_list.dart';
import 'package:drumpad_flutter/src/mvvm/views/lessons/lessons_screen.dart';
import 'package:drumpad_flutter/src/mvvm/views/loading_data/loading_data_screen.dart';
import 'package:drumpad_flutter/src/mvvm/views/profile/widget/carousel_widget.dart';
import 'package:drumpad_flutter/src/widgets/scaffold/custom_scaffold.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  List<SongCollection> randomSongs = [];
  final GlobalKey<CarouselWidgetState> _carouselKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() async {
    final drumLearnProvider = Provider.of<DrumLearnProvider>(context, listen: false);
    if(drumLearnProvider.listRecommend.isEmpty) {
      await drumLearnProvider.getRecommend();
    }
    setState(() {
      randomSongs = drumLearnProvider.listRecommend;
    });
  }

  Future<void> _refreshData() async {
    _carouselKey.currentState?.refreshData();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      backgroundType: BackgroundType.gradient,
      backgroundFit: BoxFit.cover,
      appBar: AppBar(
          leadingWidth: 100,
        toolbarHeight: 50,
        backgroundColor: Colors.transparent,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Row(
              children: [
                Icon(Icons.arrow_back_ios, color: Colors.white, size: 22),
                Text(context.locale.back, style: TextStyle(color: Colors.white, fontSize: 17),)
              ],
            ),
          ),
        ),
        title: Text(
          context.locale.your_profile,
          style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700),
        )
      ),
      body: SafeArea(
        child: Column(
          children: [
            CarouselWidget(key: _carouselKey,),
            Spacer(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    context.locale.recommend,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                SizedBox(height: 12, width: double.infinity,),
                HorizontalList(
                  width: 120,
                  height: 120,
                  data: randomSongs,
                  isShowDifficult: true,
                  onTap: (item, index) {
                    Navigator.push(context, CupertinoPageRoute(builder: (context) => LoadingDataScreen(
                      song: item,
                      callbackLoadingFailed: (){
                        Navigator.pop(context);
                      },
                      callbackLoadingCompleted: (song) async {
                        await Provider.of<AdsProvider>(context, listen: false).nextScreenFuture(context, () {
                          Navigator.pushReplacement(context, CupertinoPageRoute(builder: (context) => LessonsScreen(songCollection: song,)));
                        },);
                        _refreshData();
                      },
                    ),));
                  },
                ),
              ]
            )
          ],
        ),
      ),
    );
  }
}
