import 'package:and_drum_pad_flutter/core/res/drawer/icon.dart';
import 'package:and_drum_pad_flutter/core/utils/locator_support.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class BottomNavigation extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const BottomNavigation(
      {super.key, required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: double.infinity,
          height: 1,
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
              Color(0xFF3F3544), Color(0xFF0E0313)
            ], begin: Alignment.centerLeft, end: Alignment.centerRight)
          ),
        ),
        Container(
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 12,
                offset: Offset(0, 0),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              MediaQuery.removePadding(
                context: context,
                removeBottom: true,
                child: BottomAppBar(
                  clipBehavior: Clip.hardEdge,
                  padding: EdgeInsets.zero,
                  color: Color(0xFF0B0010).withValues(alpha: 0.8),
                  child: BottomNavigationBar(
                    iconSize: 24,
                    backgroundColor: Colors.transparent,
                    type: BottomNavigationBarType.fixed,
                    currentIndex: currentIndex,
                    elevation: 0,
                    onTap: onTap,
                    selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w400, fontSize: 12, color: Colors.white),
                    unselectedLabelStyle: TextStyle(fontWeight: FontWeight.w400, fontSize: 12, color: Color(0xFF7A6E73)),
                    items: [
                      BottomNavigationBarItem(
                          icon: Padding(
                            padding: const EdgeInsets.only(bottom: 4, top: 8),
                            child: SvgPicture.asset(ResIcon.icBeatRunner, width: 24, height: 24, colorFilter: const ColorFilter.mode(Color(0xFF7A6E73), BlendMode.srcIn))
                          ),
                          activeIcon: Padding(
                            padding: const EdgeInsets.only(bottom: 4, top: 8),
                            child: SvgPicture.asset(ResIcon.icBeatRunner, width: 24, height: 24, colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn)),
                          ),
                          label: 'Runner'
                      ),
                      BottomNavigationBarItem(
                          icon: Padding(
                              padding: const EdgeInsets.only(bottom: 4, top: 8,),
                              child: SvgPicture.asset(ResIcon.icBeatLearn, width: 24, height: 24, colorFilter: const ColorFilter.mode(Color(0xFF7A6E73), BlendMode.srcIn))
                          ),
                          activeIcon: Padding(
                            padding: const EdgeInsets.only(bottom: 4, top: 8,),
                            child: SvgPicture.asset(ResIcon.icBeatLearn, width: 24, height: 24, colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn)),
                          ),
                          label: 'Learn'
                      ),
                      BottomNavigationBarItem(
                          icon: Padding(
                              padding: const EdgeInsets.only(bottom: 4, top: 8,),
                              child: SvgPicture.asset(ResIcon.icTheme, width: 24, height: 24, colorFilter: const ColorFilter.mode(Color(0xFF7A6E73), BlendMode.srcIn))
                          ),
                          activeIcon: Padding(
                            padding: const EdgeInsets.only(bottom: 4, top: 8,),
                            child: SvgPicture.asset(ResIcon.icTheme, width: 24, height: 24, colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn)),
                          ),
                          label: 'Themes'
                      ),
                      BottomNavigationBarItem(
                          icon: Padding(
                              padding: const EdgeInsets.only(bottom: 4, top: 8),
                              child: SvgPicture.asset(ResIcon.icProfile, width: 24, height: 24, colorFilter: const ColorFilter.mode(Color(0xFF7A6E73), BlendMode.srcIn))
                          ),
                          activeIcon: Padding(
                            padding: const EdgeInsets.only(bottom: 4, top: 8),
                            child: SvgPicture.asset(ResIcon.icProfile, width: 24, height: 24, colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn)),
                          ),
                          label: 'Profile'
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        // Consumer<AppStateProvider>(
        //   builder: (context, appStateProvider, _) {
        //     return CollapsibleBannerAdWidget(
        //       key: ValueKey(!appStateProvider.shouldShowAds),
        //       adName: "banner_collap_home",
        //       disabled: !appStateProvider.shouldShowAds);
        //   }
        // ),

      ],
    );
  }
}