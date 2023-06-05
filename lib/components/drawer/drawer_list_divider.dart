import 'package:flutter/material.dart';

class DrawerListDivider extends StatelessWidget {
  const DrawerListDivider({
    super.key,
    required this.title,
    this.titleColor = const Color(0xFFF2F3F5),
  });

  final String title;
  final Color titleColor;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(
          left: 20,
          top: 25,
          bottom: 8,
        ),
        child: Text(
          title,
          style: TextStyle(
            color: titleColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
