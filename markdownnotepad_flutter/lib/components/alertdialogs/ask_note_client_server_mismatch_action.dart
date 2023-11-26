// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_modular/flutter_modular.dart'
    show Modular, ModularWatchExtension;
import 'package:markdownnotepad/helpers/date_helper.dart';
import 'package:markdownnotepad/providers/drawer_current_tab_provider.dart';

class AskNoteClientServerMismatchAction extends StatelessWidget {
  final VoidCallback overrideNoteFunction;
  final VoidCallback saveNoteToCache;

  final DateTime cacheLastUpdate;
  final DateTime serverLastUpdate;

  const AskNoteClientServerMismatchAction({
    super.key,
    required this.overrideNoteFunction,
    required this.saveNoteToCache,
    required this.cacheLastUpdate,
    required this.serverLastUpdate,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(8.0),
        ),
      ),
      title: const Text('Uwaga!'),
      content: Text(
        'Istnieje różnica w dacie edycji notatki znajdującej się w pamięci podręcznej i na serwerze.\nData ostatniej edycji notatki, znajdującej się w pamięci podręcznej: ${DateHelper.getFormattedDateTime(cacheLastUpdate)}\nData ostatniej edycji notatki, znajdującej się na serwerze: ${DateHelper.getFormattedDateTime(serverLastUpdate)}\nCzy chcesz nadpisać notatkę w pamięci podręcznej?',
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            Modular.to.navigate('/dashboard/');
            context
                .read<DrawerCurrentTabProvider>()
                .setCurrentTab("/dashboard/");
          },
          child: const Text('Wróć do dashboardu'),
        ),
        TextButton(
          onPressed: overrideNoteFunction,
          child: const Text('Nadpisz notatkę na serwerze'),
        ),
        TextButton(
          onPressed: saveNoteToCache,
          child: const Text('Nadpisz notatkę w pamięci podręcznej'),
        ),
      ],
    )
        .animate()
        .fadeIn(
          duration: 100.ms,
        )
        .scale(
          duration: 100.ms,
          curve: Curves.easeInOut,
          begin: const Offset(0, 0),
          end: const Offset(1, 1),
        );
  }
}
