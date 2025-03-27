import 'package:drumpad_flutter/src/widgets/blur_widget.dart';
import 'package:flutter/material.dart';

class ItemCategorySong extends StatelessWidget {
  final String asset;
  const ItemCategorySong({super.key, required this.asset});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).width * 0.17;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      child: Row(
        spacing: 12,
        children: [
          Container(
            height: height,
            width: height,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              image: DecorationImage(image: AssetImage(asset), fit: BoxFit.cover))
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 4,
            children: [
              Text('Nac Choi', style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w600)),
              Text('Nac Choi', style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w400)),
              BlurWidget(text: 'HARD',),
            ],
          )
        ],
      ),
    );
  }
}
