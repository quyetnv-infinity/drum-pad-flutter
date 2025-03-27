import 'package:flutter/material.dart';

class FeedbackItem extends StatefulWidget {
  final String text;
  const FeedbackItem({super.key, required this.text});

  @override
  State<FeedbackItem> createState() => _FeedbackItemState();
}

class _FeedbackItemState extends State<FeedbackItem> {
  bool _isSelected = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        setState(() {
          _isSelected = !_isSelected;
        });
      },
      child: Container(
        height: 36,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white.withValues(alpha: 0.5),
            border: _isSelected ? Border.all(color: Colors.black, width: 1.5) : null
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(width: 12,),
            const Text('😕', style: TextStyle(fontSize: 28, height: 1.2),),
            const SizedBox(width: 12,),
            Text(widget.text, style: const TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w400),)
          ],
        ),
      ),
    );
  }
}