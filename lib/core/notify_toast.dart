import 'package:flutter/material.dart';
import 'package:markdownnotepad/components/draggable_widget.dart';

class NotifyToast {
  late OverlayState overlayState;
  OverlayEntry? entry;

  void show({
    required BuildContext context,
    required Widget child,
  }) async {
    overlayState = Overlay.of(context);

    if (entry != null) {
      entry!.remove();
    }
    entry = OverlayEntry(
      builder: (context) {
        return DraggableWidget(
          onRemove: () {
            entry!.remove();
            entry = null;
          },
          child: Material(
            color: Colors.transparent,
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: child,
            ),
          ),
        );
      },
    );

    overlayState.insert(entry!);
  }
}
