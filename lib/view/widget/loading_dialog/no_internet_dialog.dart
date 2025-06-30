import 'package:and_drum_pad_flutter/core/res/drawer/image.dart';
import 'package:and_drum_pad_flutter/core/utils/locator_support.dart';
import 'package:base_ui_flutter_v1/base_ui_flutter_v1.dart';
import 'package:flutter/material.dart';

class NoInternetDialog extends DialogBase {
  Function() onTapGoSettings;

  NoInternetDialog({required this.onTapGoSettings});

  @override
  Future<void> onShow(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          child: Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(32),
              gradient: RadialGradient(colors: [Color(0xff33114d), Color(0xff7727b3)], center: Alignment.bottomCenter)
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(ResImage.imgNoInternet, width: MediaQuery.of(context).size.width*0.5, height: MediaQuery.of(context).size.width*0.5, fit: BoxFit.cover,),
                Text(context.locale.no_internet_connection, style: TextStyle(fontWeight: FontWeight.w500, color: Colors.white),),
                SizedBox(height: 4),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Text(context.locale.no_internet_connection_description, textAlign: TextAlign.center, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.white.withValues(alpha: 0.6))),
                ),
                SizedBox(height: 28),
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(30),
                    onTap: onTapGoSettings,
                    child: Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.symmetric(vertical: 16),
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        gradient: LinearGradient(colors: [Color(0xffa005ff), Color(0xffd796ff)])
                      ),
                      child: Text(context.locale.go_settings, maxLines:1, overflow: TextOverflow.ellipsis,style: TextStyle(fontWeight: FontWeight.w500, color: Colors.white),),
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

}