import 'package:collection/collection.dart';
import 'package:dynamic_height_grid_view/dynamic_height_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:markdownnotepad/models/note.dart';
import 'package:markdownnotepad/models/notetag.dart';
import 'package:markdownnotepad/viewmodels/logged_in_user.dart';
import 'package:material_symbols_icons/symbols.dart';

class AssignNoteToNoteTagsAlertDialog extends StatefulWidget {
  final LoggedInUser? loggedInUser;
  final Note note;
  final Function(List<String>) assignNoteTags;

  const AssignNoteToNoteTagsAlertDialog({
    super.key,
    required this.loggedInUser,
    required this.note,
    required this.assignNoteTags,
  });

  @override
  State<AssignNoteToNoteTagsAlertDialog> createState() =>
      _AssignNoteToNoteTagsAlertDialogState();
}

class _AssignNoteToNoteTagsAlertDialogState
    extends State<AssignNoteToNoteTagsAlertDialog> {
  List<String> selectedNoteTagsId = [];
  List<String> noteTagsId = [];

  @override
  void initState() {
    super.initState();
    selectedNoteTagsId = widget.note.tags?.map((e) => e.id).toList() ?? [];
    noteTagsId = widget.note.tags?.map((e) => e.id).toList() ?? [];
  }

  @override
  Widget build(BuildContext context) {
    List<NoteTag>? noteTagsToBuild = widget.loggedInUser!.user.tags;

    return AlertDialog(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(8.0),
        ),
      ),
      title: const Text('Wybierz tagi'),
      content: Container(
        constraints: BoxConstraints(
          minHeight: 100,
          maxHeight: MediaQuery.of(context).size.height * .8,
        ),
        width: 250,
        child: SingleChildScrollView(
          child: (noteTagsToBuild == null || noteTagsToBuild.isEmpty)
              ? const Center(
                  child: Opacity(
                    opacity: .7,
                    child: Text("Brak tagów możliwych do przypisania"),
                  ),
                )
              : buildTwoColumnGrid(noteTagsToBuild, selectedNoteTagsId,
                  (String nID) {
                  List<String> sn = selectedNoteTagsId;
                  if (sn.contains(nID)) {
                    sn.remove(nID);
                  } else {
                    sn.add(nID);
                  }

                  setState(() {
                    selectedNoteTagsId = sn;
                  });
                }),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text("Anuluj"),
        ),
        TextButton(
          onPressed: const ListEquality<String>()
                  .equals(selectedNoteTagsId, noteTagsId)
              ? null
              : () {
                  Navigator.of(context).pop();
                  widget.assignNoteTags(selectedNoteTagsId);
                },
          child: const Text("Przypisz"),
        ),
      ],
    );
  }
}

Widget buildTwoColumnGrid(
  List<NoteTag>? items,
  List<String> selectedIDs,
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
      final NoteTag item = items[index];

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
              selectedIDs.contains(item.id)
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
