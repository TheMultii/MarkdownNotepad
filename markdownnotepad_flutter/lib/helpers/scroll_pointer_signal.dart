import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

void handleScrollPointerSignal(
  PointerSignalEvent pointerSignal,
  ScrollController scrollController, {
  double speedMultiplier = 1.0,
}) {
  if (!(kIsWeb || Platform.isWindows || Platform.isLinux || Platform.isMacOS)) {
    return;
  }

  if (pointerSignal is PointerScrollEvent) {
    final newOffset = scrollController.offset +
        pointerSignal.scrollDelta.dy * speedMultiplier;
    final double destination = newOffset < 0
        ? 0
        : newOffset > scrollController.position.maxScrollExtent
            ? scrollController.position.maxScrollExtent
            : newOffset;

    scrollController.jumpTo(destination);
  }
}
