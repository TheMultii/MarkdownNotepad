import 'package:flutter/material.dart';

class MDNDrawerItemSection extends StatelessWidget {
  final String title;
  final Icon? icon;
  final VoidCallback? iconClickCallback;

  const MDNDrawerItemSection({
    super.key,
    required this.title,
    this.icon,
    this.iconClickCallback,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 20.0,
        left: 20.0,
        right: 20.0,
        bottom: 8.0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          if (icon != null)
            IconButton(
              icon: icon!,
              onPressed: iconClickCallback,
              padding: const EdgeInsets.all(4),
              constraints: const BoxConstraints(),
            ),
        ],
      ),
    );
  }
}
