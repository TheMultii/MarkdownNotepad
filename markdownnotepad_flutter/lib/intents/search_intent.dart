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
    LogicalKeyboardKey.keyP,
    control: true,
    shift: true,
  );

  @override
  Widget build(BuildContext context) {
    return Shortcuts(
      // ignore: prefer_const_literals_to_create_immutables
      shortcuts: {
        controlShiftF: const SearchIntent(),
      },
      child: Actions(
        actions: <Type, Action<Intent>>{
          SearchIntent: CallbackAction<Intent>(
            onInvoke: (Intent intent) {
              invokeFunction(intent);
              return null;
            },
          ),
        },
        child: child,
      ),
    );
  }
}
