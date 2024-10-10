import 'package:flutter/material.dart';

class TitleTextWidget extends StatelessWidget {
  const TitleTextWidget({
    super.key,
    required this.label,
    this.fontSize = 18,
    this.color,
    this.maxLines,
    this.decoration = TextDecoration.none,
  });
  final String label;
  final double fontSize;
  final Color? color;
  final int? maxLines;
  final TextDecoration? decoration;
  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      maxLines: maxLines,
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: FontWeight.bold,
        color: color,
        decoration: decoration,
        // overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
