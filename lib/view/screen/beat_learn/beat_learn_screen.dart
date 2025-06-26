import 'package:and_drum_pad_flutter/core/res/drawer/icon.dart';
import 'package:and_drum_pad_flutter/core/res/drawer/image.dart';
import 'package:and_drum_pad_flutter/core/res/style/text_style.dart';
import 'package:and_drum_pad_flutter/core/utils/locator_support.dart';
import 'package:and_drum_pad_flutter/data/model/lesson_model.dart';
import 'package:and_drum_pad_flutter/view/screen/beat_runner/widget/recommend_list_song.dart';
import 'package:and_drum_pad_flutter/view/screen/campaign/campaign_screen.dart';
import 'package:and_drum_pad_flutter/view/screen/learn_material/learn_material_screen.dart';
import 'package:and_drum_pad_flutter/view/widget/button/icon_button_custom.dart';
import 'package:and_drum_pad_flutter/view/widget/item/mode_play_item.dart';
import 'package:and_drum_pad_flutter/view/widget/scaffold/custom_scaffold.dart';
import 'package:and_drum_pad_flutter/view_model/drum_learn_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BeatLearnScreen extends StatelessWidget {
  const BeatLearnScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Cache MediaQuery để tránh rebuild không cần thiết
    final screenWidth = MediaQuery.sizeOf(context).width;
    
    return AppScaffold(
      appBar: AppBar(
        leadingWidth: screenWidth * 0.5,
        leading: const Padding(
          padding: EdgeInsets.only(left: 16, top: 10),
          child: _AppBarTitle(),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 0),
            child: _SettingsButton(),
          )
        ],
      ),
      body: const SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: _BeatLearnBody(),
        ),
      ),
    );
  }
}

class _AppBarTitle extends StatelessWidget {
  const _AppBarTitle();

  @override
  Widget build(BuildContext context) {
    return Text(
      context.locale.beat_learn,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: const TextStyle(fontSize: 20, fontFamily: AppFonts.commando),
    );
  }
}

class _SettingsButton extends StatelessWidget {
  const _SettingsButton();

  @override
  Widget build(BuildContext context) {
    return IconButtonCustom(
      iconAsset: ResIcon.icSetting,
      onTap: () {
        // TODO: Implement settings functionality
      },
    );
  }
}

class _BeatLearnBody extends StatelessWidget {
  const _BeatLearnBody();

  @override
  Widget build(BuildContext context) {
    
    print("Building BeatLearnBody");
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 8,
      children: [
        // Sử dụng Selector thay vì Consumer để chỉ rebuild khi listSongResume thay đổi
        Selector<DrumLearnProvider, List<SongCollection>>(
          selector: (context, provider) => provider.listSongResume,
          builder: (context, listSongResume, child) {
            if (listSongResume.isEmpty) {
              return const SizedBox.shrink(); // Tối ưu hơn Container()
            }
            
            return Flexible(
              child: RecommendListSong(
                title: context.locale.recent_list_song,
                listSongs: listSongResume,
                onTapItem: (song) {
                  // TODO: Implement song selection
                },
              ),
            );
          },
        ),
        // Extract thành widget riêng để tránh rebuild
        const _ModePlayLabel(),
        _LearnMaterialItem(context),
        _CampaignItem(context),
      ],
    );
  }
}

class _ModePlayLabel extends StatelessWidget {
  const _ModePlayLabel();

  @override
  Widget build(BuildContext context) {
    return Text(
      context.locale.mode_play,
      style: TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 14,
        color: Colors.white.withValues(alpha: 0.8),
      ),
    );
  }
}

// Tách thành methods để tránh tạo widget mới mỗi lần rebuild
Widget _LearnMaterialItem(BuildContext context) {
  return ModePlayItem(
    asset: ResImage.imgBgLearnMaterial,
    title: context.locale.learn_material,
    description: context.locale.learn_material_des,
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const LearnMaterialScreen()),
      );
    },
  );
}

Widget _CampaignItem(BuildContext context) {
  return ModePlayItem(
    asset: ResImage.imgBgCampaign,
    title: context.locale.campaign,
    description: context.locale.campaign_des,
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const CampaignScreen()),
      );
    },
  );
}
