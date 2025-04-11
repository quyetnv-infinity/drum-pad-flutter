import 'package:drumpad_flutter/core/res/drawer/image.dart';
import 'package:flutter/material.dart';

class ModeButton extends StatefulWidget {
  final String title;
  final Function(bool) onSelected;
  final bool initialSelected;

  const ModeButton({
    super.key,
    required this.title,
    required this.onSelected,
    required this.initialSelected,
  });

  @override
  _ModeButtonState createState() => _ModeButtonState();
}

class _ModeButtonState extends State<ModeButton> {
  late bool isSelected;

  @override
  void initState() {
    super.initState();
    isSelected = widget.initialSelected;
  }

  void _toggleSelection() {
    setState(() {
      isSelected = !isSelected;
    });
    widget.onSelected(isSelected);
  }
  @override
  void didUpdateWidget(covariant ModeButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialSelected != widget.initialSelected) {
      setState(() {
        isSelected = widget.initialSelected;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: _toggleSelection,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),  
          image: DecorationImage(image:AssetImage(ResImage.imgBGMode), fit: BoxFit.cover),
        ),
        child: Text(
          widget.title,
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: isSelected ? Colors.black : Colors.white,
          ),
        ),
      ),
    );
  }
}
