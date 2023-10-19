import 'package:flutter/material.dart';

class AvatarWithStatus extends StatelessWidget {
  final Widget child;
  final Color colorStatus;
  final double statusSize;
  final Color? borderColor;

  const AvatarWithStatus({
    super.key,
    required this.child,
    required this.colorStatus,
    this.statusSize = 12,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        Positioned(
          bottom: 0,
          right: 0,
          child: Container(
            width: statusSize,
            height: statusSize,
            decoration: BoxDecoration(
              color: colorStatus,
              shape: BoxShape.circle,
              border: Border.all(
                color: borderColor ?? Theme.of(context).colorScheme.background,
                width: 2,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
