import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SearchIntent extends Intent {
  const SearchIntent();
}

class MDNSearchIntent extends StatelessWidget {
  final Widget child;
  final Function(Intent intent) invokeFunction;

  const MDNSearchIntent({
    super.key,
    required this.child,
    required this.invokeFunction,
  });

  final controlShiftF = const SingleActivator(
    LogicalKeyboardKey.keyF,
    control: true,
    shift: true,
  );

  @override
  Widget build(BuildContext context) {
    return Shortcuts(
      shortcuts: {
        controlShiftF: const SearchIntent(),
      },
      child: Actions(
        actions: <Type, Action<Intent>>{
          SearchIntent: CallbackAction<Intent>(
            onInvoke: invokeFunction,
          ),
        },
        child: child,
      ),
    );
  }
}