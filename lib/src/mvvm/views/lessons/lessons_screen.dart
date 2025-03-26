import 'package:drumpad_flutter/core/res/style/text_style.dart';
import 'package:drumpad_flutter/src/widgets/scaffold/custom_scaffold.dart';
import 'package:flutter/material.dart';

class LessonsScreen extends StatefulWidget {
  const LessonsScreen({super.key});

  @override
  State<LessonsScreen> createState() => _LessonsScreenState();
}

class _LessonsScreenState extends State<LessonsScreen> {
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leadingWidth: 100,
        leading: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: const [
            SizedBox(width: 12),
            Icon(Icons.arrow_back_ios, size: 18),
            SizedBox(width: 4),
            Text(
              "Back",
              style: TextStyle(fontSize: 17, fontWeight: AppFonts.regular),
            ),
          ],
        ),
        title: Text(
          "Campaign",
          style: TextStyle(fontSize: 20, fontWeight: AppFonts.bold),
        ),
      ),
    );
  }
}
