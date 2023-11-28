import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class EditorCtrl1Intent extends Intent {
  const EditorCtrl1Intent();
}

class EditorCtrl2Intent extends Intent {
  const EditorCtrl2Intent();
}

class EditorCtrl3Intent extends Intent {
  const EditorCtrl3Intent();
}

class EditorCtrl4Intent extends Intent {
  const EditorCtrl4Intent();
}

class EditorCtrl5Intent extends Intent {
  const EditorCtrl5Intent();
}

class EditorCtrl6Intent extends Intent {
  const EditorCtrl6Intent();
}

class MDNEditorIntent extends StatelessWidget {
  final Widget child;
  final Function(Intent intent) invokeFunction;

  const MDNEditorIntent({
    super.key,
    required this.child,
    required this.invokeFunction,
  });

  final control1 = const SingleActivator(
    LogicalKeyboardKey.digit1,
    control: true,
  );

  final control2 = const SingleActivator(
    LogicalKeyboardKey.digit2,
    control: true,
  );

  final control3 = const SingleActivator(
    LogicalKeyboardKey.digit3,
    control: true,
  );

  final control4 = const SingleActivator(
    LogicalKeyboardKey.digit4,
    control: true,
  );

  final control5 = const SingleActivator(
    LogicalKeyboardKey.digit5,
    control: true,
  );

  final control6 = const SingleActivator(
    LogicalKeyboardKey.digit6,
    control: true,
  );

  @override
  Widget build(BuildContext context) {
    return Shortcuts(
      // ignore: prefer_const_literals_to_create_immutables
      shortcuts: {
        control1: const EditorCtrl1Intent(),
        control2: const EditorCtrl2Intent(),
        control3: const EditorCtrl3Intent(),
        control4: const EditorCtrl4Intent(),
        control5: const EditorCtrl5Intent(),
        control6: const EditorCtrl6Intent(),
      },
      child: Actions(
        actions: <Type, Action<Intent>>{
          EditorCtrl1Intent: CallbackAction<Intent>(
            onInvoke: (Intent intent) {
              invokeFunction(intent);
              return null;
            },
          ),
          EditorCtrl2Intent: CallbackAction<Intent>(
            onInvoke: (Intent intent) {
              invokeFunction(intent);
              return null;
            },
          ),
          EditorCtrl3Intent: CallbackAction<Intent>(
            onInvoke: (Intent intent) {
              invokeFunction(intent);
              return null;
            },
          ),
          EditorCtrl4Intent: CallbackAction<Intent>(
            onInvoke: (Intent intent) {
              invokeFunction(intent);
              return null;
            },
          ),
          EditorCtrl5Intent: CallbackAction<Intent>(
            onInvoke: (Intent intent) {
              invokeFunction(intent);
              return null;
            },
          ),
          EditorCtrl6Intent: CallbackAction<Intent>(
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
