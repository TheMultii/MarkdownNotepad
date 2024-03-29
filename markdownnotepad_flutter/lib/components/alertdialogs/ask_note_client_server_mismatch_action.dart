import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:markdownnotepad/helpers/date_helper.dart';
import 'package:markdownnotepad/helpers/navigation_helper.dart';

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
        'Istnieje różnica w dacie edycji notatki znajdującej się w pamięci podręcznej i na serwerze.\n\nData ostatniej edycji notatki, znajdującej się w pamięci podręcznej: ${DateHelper.getFormattedDateTime(cacheLastUpdate)}\nData ostatniej edycji notatki, znajdującej się na serwerze: ${DateHelper.getFormattedDateTime(serverLastUpdate)}\n\nCzy chcesz nadpisać notatkę w pamięci podręcznej?',
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            NavigationHelper.navigateToPage(context, '/dashboard/');
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
