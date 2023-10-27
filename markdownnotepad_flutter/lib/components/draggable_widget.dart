import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:markdownnotepad/enums/horizontal_alignment.dart';

class DraggableWidget extends StatefulWidget {
  final Widget child;
  final VoidCallback onRemove;
  final Duration durationToDismiss;
  final HorizontalAlignment alignment;

  const DraggableWidget({
    super.key,
    required this.child,
    required this.onRemove,
    this.durationToDismiss = const Duration(seconds: 3),
    this.alignment = HorizontalAlignment.right,
  });

  @override
  State<DraggableWidget> createState() => _DraggableWidgetState();
}

class _DraggableWidgetState extends State<DraggableWidget> {
  double offsetY = 0.0;
  double originalY = 0.0;
  bool isDragging = false;
  Timer? disposeTimer;

  @override
  void initState() {
    super.initState();

    registerDispose();
  }

  @override
  void dispose() {
    disposeTimer?.cancel();
    super.dispose();
  }

  void registerDispose() {
    disposeTimer = Timer(widget.durationToDismiss, () {
      setState(() {
        offsetY = -125;
      });
    });
  }

  void stopDisposeTimer() {
    disposeTimer?.cancel();
  }

  void onDragStart(DragStartDetails details) {
    if (!mounted) return;
    stopDisposeTimer();

    originalY = offsetY;
    setState(() {
      isDragging = true;
    });
  }

  void onDrag(DragUpdateDetails details) {
    if (!mounted) return;

    setState(() {
      offsetY += details.delta.dy;
    });
  }

  void onDragEnd(DragEndDetails details) {
    if (!mounted) return;

    setState(() {
      isDragging = false;
    });

    if (offsetY < -100) {
      widget.onRemove();
      return;
    }
    setState(() {
      offsetY = originalY;
    });

    registerDispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLeftAlignment = widget.alignment == HorizontalAlignment.left;

    return AnimatedPositioned(
      duration: isDragging ? 0.ms : 200.ms,
      left: isLeftAlignment ? 0 : null,
      right: isLeftAlignment ? null : 0,
      top: offsetY,
      child: GestureDetector(
        onPanStart: onDragStart,
        onPanUpdate: onDrag,
        onPanEnd: onDragEnd,
        onTap: () => widget.onRemove(),
        child: widget.child
            .animate()
            .slideY(
              duration: 250.ms,
              curve: Curves.easeOut,
            )
            .fadeIn(
              duration: 250.ms,
              curve: Curves.easeOut,
            ),
      ),
    );
  }
}
