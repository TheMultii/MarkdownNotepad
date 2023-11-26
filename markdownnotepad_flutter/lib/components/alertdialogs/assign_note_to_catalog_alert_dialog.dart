import 'package:dynamic_height_grid_view/dynamic_height_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:markdownnotepad/models/note.dart';
import 'package:markdownnotepad/viewmodels/logged_in_user.dart';
import 'package:material_symbols_icons/symbols.dart';

class AssignNoteToCatalogAlertDialog extends StatefulWidget {
  final LoggedInUser? loggedInUser;
  final String directoryId;
  final Function(String) assignNote;

  const AssignNoteToCatalogAlertDialog({
    super.key,
    required this.loggedInUser,
    required this.directoryId,
    required this.assignNote,
  });

  @override
  State<AssignNoteToCatalogAlertDialog> createState() =>
      _AssignNoteToCatalogAlertDialogState();
}

class _AssignNoteToCatalogAlertDialogState
    extends State<AssignNoteToCatalogAlertDialog> {
  String selectedNoteID = "";

  @override
  Widget build(BuildContext context) {
    List<Note>? notesToBuild = widget.loggedInUser!.user.notes
        ?.where((element) => element.folder?.id != widget.directoryId)
        .toList();

    return AlertDialog(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(8.0),
        ),
      ),
      title: const Text('Wybierz notatkę'),
      content: Container(
        constraints: BoxConstraints(
          minHeight: 100,
          maxHeight: MediaQuery.of(context).size.height * .8,
        ),
        width: 250,
        child: SingleChildScrollView(
          child: (notesToBuild == null || notesToBuild.isEmpty)
              ? const Center(
                  child: Opacity(
                    opacity: .7,
                    child: Text("Brak notatek możliwych do przypisania"),
                  ),
                )
              : buildTwoColumnGrid(
                  notesToBuild,
                  selectedNoteID,
                  (String nID) => setState(
                    () => selectedNoteID = nID,
                  ),
                ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text("Anuluj"),
        ),
        TextButton(
          onPressed: selectedNoteID == ""
              ? null
              : () {
                  Navigator.of(context).pop();
                  widget.assignNote(selectedNoteID);
                },
          child: const Text("Przypisz"),
        ),
      ],
    );
  }
}

Widget buildTwoColumnGrid(
  List<Note>? items,
  String selectedID,
  Function(String) onTap,
) {
  if (items == null || items.isEmpty) {
    return Container();
  }

  return DynamicHeightGridView(
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    crossAxisCount: 2,
    crossAxisSpacing: 8.0,
    mainAxisSpacing: 8.0,
    itemCount: items.length,
    builder: (context, index) {
      final Note item = items[index];

      return InkWell(
        borderRadius: BorderRadius.circular(4),
        onTap: () => onTap(item.id),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 4.0,
            vertical: 2.0,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              selectedID == item.id
                  ? const Padding(
                      padding: EdgeInsets.only(right: 4.0),
                      child: Icon(
                        Symbols.check,
                        size: 14,
                        color: Colors.green,
                      ),
                    ).animate().fadeIn(
                        duration: 100.ms,
                      )
                  : const SizedBox(),
              Text(
                item.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      );
    },
  );
}
