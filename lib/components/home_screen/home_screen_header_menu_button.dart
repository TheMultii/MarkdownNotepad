import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class HeaderMenuButton extends StatelessWidget {
  const HeaderMenuButton({
    super.key,
    required this.text,
    this.isSelected = false,
    this.onTap,
  });

  final String text;
  final bool isSelected;
  final Function? onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
        bottom: 1,
      ),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: isSelected
                ? Theme.of(context).colorScheme.primary
                : Colors.transparent,
            width: 1.5,
          ),
        ),
      ),
      child: RichText(
        text: TextSpan(
          //operator kaskadowy (..)
          recognizer: TapGestureRecognizer()..onTap = () => onTap!(text),
          text: text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
