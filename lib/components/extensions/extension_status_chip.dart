import 'package:flutter/material.dart';
import 'package:markdownnotepad/components/extensions/extension_tag_color.dart';
import 'package:markdownnotepad/enums/extension_status.dart';

class ExtensionStatusChip extends StatelessWidget {
  final ExtensionStatus status;

  const ExtensionStatusChip({
    super.key,
    required this.status,
  });

  String extensionStatus() {
    switch (status) {
      case ExtensionStatus.active:
        return "Aktywny";
      case ExtensionStatus.inactive:
        return "Nieaktywny";
      case ExtensionStatus.invalid:
        return "Nieprawidłowy";
      default:
        return "Nieznany";
    }
  }

  ExtensionTagColor extensionColor() {
    switch (status) {
      case ExtensionStatus.active:
        return const ExtensionTagColor(
          borderColor: Color(0xFF00B087),
        );
      case ExtensionStatus.inactive:
        return ExtensionTagColor(
          borderColor: const Color(0xFFFFFFFF).withOpacity(.6),
        );
      case ExtensionStatus.invalid:
        return const ExtensionTagColor(
          backgroundColor: Color(0xFFFFC5C5),
          borderColor: Color(0xFFDF0404),
        );
      default:
        return const ExtensionTagColor(
          borderColor: Color(0xFF00B087),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    ExtensionTagColor extensionTagColor = extensionColor();

    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: extensionTagColor.borderColor,
          width: 1.0,
        ),
        color: extensionTagColor.backgroundColor,
        borderRadius: BorderRadius.circular(4.0),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 12.0,
          vertical: 2.0,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              extensionStatus(),
              style: TextStyle(
                fontSize: 13,
                color: extensionTagColor.borderColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
