import 'package:dynamic_height_grid_view/dynamic_height_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:markdownnotepad/models/catalog.dart';
import 'package:markdownnotepad/models/note.dart';
import 'package:markdownnotepad/viewmodels/logged_in_user.dart';
import 'package:material_symbols_icons/symbols.dart';

class AssignCatalogAlertDialog extends StatefulWidget {
  final LoggedInUser loggedInUser;
  final Note note;
  final Function(String) assignCatalog;

  const AssignCatalogAlertDialog({
    super.key,
    required this.loggedInUser,
    required this.note,
    required this.assignCatalog,
  });

  @override
  State<AssignCatalogAlertDialog> createState() =>
      _AssignCatalogAlertDialogState();
}

class _AssignCatalogAlertDialogState extends State<AssignCatalogAlertDialog> {
  String selectedCatalogID = "";
  String initialCatalogSelected = "";

  @override
  void initState() {
    super.initState();

    initialCatalogSelected = selectedCatalogID = widget.note.folder?.id ?? "";
  }

  @override
  Widget build(BuildContext context) {
    List<Catalog>? catalogsToBuild = widget.loggedInUser.user.catalogs;

    return AlertDialog(
      title: const Text('Wybierz katalog'),
      content: Container(
        constraints: BoxConstraints(
          minHeight: 100,
          maxHeight: MediaQuery.of(context).size.height * .8,
        ),
        width: 250,
        child: SingleChildScrollView(
          child: (catalogsToBuild == null || catalogsToBuild.isEmpty)
              ? const Center(
                  child: Opacity(
                    opacity: .7,
                    child: Text("Brak folderów możliwych do przypisania"),
                  ),
                )
              : buildTwoColumnGrid(
                  catalogsToBuild,
                  selectedCatalogID,
                  (String cID) => setState(
                    () => selectedCatalogID = cID,
                  ),
                ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text("Anuluj"),
        ),
        widget.note.folder == null
            ? const SizedBox()
            : TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  widget.assignCatalog("");
                },
                child: const Text(
                  "Usuń przypisanie",
                ),
              ),
        TextButton(
          onPressed: selectedCatalogID == ""
              ? null
              : () {
                  Navigator.of(context).pop();
                  if (initialCatalogSelected == selectedCatalogID) return;
                  widget.assignCatalog(selectedCatalogID);
                },
          child: const Text("Przypisz"),
        ),
      ],
    );
  }
}

Widget buildTwoColumnGrid(
  List<Catalog>? items,
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
      final Catalog item = items[index];

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
