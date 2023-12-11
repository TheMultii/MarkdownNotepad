import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class EditorCtrlTabIntent extends Intent {
  const EditorCtrlTabIntent();
}

class EditorCtrlSIntent extends Intent {
  const EditorCtrlSIntent();
}

class EditorCtrlShiftOIntent extends Intent {
  const EditorCtrlShiftOIntent();
}

class EditorCtrlShiftBIntent extends Intent {
  const EditorCtrlShiftBIntent();
}

class MDNEditorPageIntent extends StatelessWidget {
  final Widget child;
  final FocusNode focusNode;
  final Function(Intent intent) invokeCtrlTab;
  final Function(Intent intent) invokeCtrlS;
  final Function(Intent intent) invokeCtrlShiftO;
  final Function(Intent intent) invokeCtrlShiftB;

  const MDNEditorPageIntent({
    super.key,
    required this.child,
    required this.focusNode,
    required this.invokeCtrlTab,
    required this.invokeCtrlS,
    required this.invokeCtrlShiftO,
    required this.invokeCtrlShiftB,
  });

  final controlTab = const SingleActivator(
    LogicalKeyboardKey.tab,
    control: true,
  );

  final controlS = const SingleActivator(
    LogicalKeyboardKey.keyS,
    control: true,
  );

  final controlShiftO = const SingleActivator(
    LogicalKeyboardKey.keyO,
    shift: true,
    control: true,
  );

  final controlShiftB = const SingleActivator(
    LogicalKeyboardKey.keyB,
    shift: true,
    control: true,
  );

  @override
  Widget build(BuildContext context) {
    return Shortcuts(
      // ignore: prefer_const_literals_to_create_immutables
      shortcuts: {
        controlTab: const EditorCtrlTabIntent(),
        controlS: const EditorCtrlSIntent(),
        controlShiftO: const EditorCtrlShiftOIntent(),
        controlShiftB: const EditorCtrlShiftBIntent(),
      },
      child: Actions(
        actions: <Type, Action<Intent>>{
          EditorCtrlTabIntent: CallbackAction<Intent>(
            onInvoke: (Intent intent) {
              invokeCtrlTab(intent);
              focusNode.requestFocus();
              return null;
            },
          ),
          EditorCtrlSIntent: CallbackAction<Intent>(
            onInvoke: (Intent intent) {
              invokeCtrlS(intent);
              return null;
            },
          ),
          EditorCtrlShiftOIntent: CallbackAction<Intent>(
            onInvoke: (Intent intent) {
              invokeCtrlShiftO(intent);
              focusNode.requestFocus();
              return null;
            },
          ),
          EditorCtrlShiftBIntent: CallbackAction<Intent>(
            onInvoke: (Intent intent) {
              invokeCtrlShiftB(intent);
              focusNode.requestFocus();
              return null;
            },
          ),
        },
        child: child,
      ),
    );
  }
}
