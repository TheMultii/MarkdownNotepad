import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_context_menu/flutter_context_menu.dart';
import 'package:markdownnotepad/components/alertdialogs/assign_catalog_alert_dialog.dart';
import 'package:markdownnotepad/components/notifications/info_notify_toast.dart';
import 'package:markdownnotepad/core/notify_toast.dart';
import 'package:markdownnotepad/helpers/save_file_helper.dart';
import 'package:markdownnotepad/models/note.dart';
import 'package:markdownnotepad/viewmodels/logged_in_user.dart';

List<ContextMenuEntry> getEditorContextMenu({
  required BuildContext context,
  required Note note,
  required String textToRender,
  required bool isLiveShareEnabled,
  required VoidCallback toggleLiveShare,
  required VoidCallback changeNoteName,
  required VoidCallback deleteNote,
  required Function(String) assignCatalog,
  required LoggedInUser? loggedInUser,
}) {
  return [
    const MenuHeader(text: "Opcje"),
    MenuItem.submenu(
      label: 'Eksportuj',
      icon: Icons.edit,
      items: [
        MenuItem(
          label: 'Eksportuj do MD',
          icon: Icons.save,
          onSelected: () async {
            SaveFileHelper.saveTextFile(
              context,
              "${note.id}.md",
              textToRender,
            );
          },
        ),
      ],
    ),
    const MenuDivider(),
    MenuItem(
      label: 'Zmień nazwę',
      icon: Icons.edit,
      onSelected: changeNoteName,
    ),
    MenuItem(
      label: 'Przypisz do katalogu',
      icon: Icons.create_new_folder,
      onSelected: () {
        showDialog(
          context: context,
          builder: (context) {
            return AssignCatalogAlertDialog(
              loggedInUser: loggedInUser!,
              note: note,
              assignCatalog: assignCatalog,
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
          },
        );
      },
    ),
    MenuItem(
      label: 'Zmień tagi',
      icon: Icons.tag,
      onSelected: () {},
    ),
    const MenuDivider(),
    MenuItem(
      label: isLiveShareEnabled ? 'Wyłącz live share' : 'Włącz live share',
      icon: Icons.share,
      onSelected: toggleLiveShare,
    ),
    MenuItem(
      label: 'Zapisz',
      icon: Icons.save,
      onSelected: () async {
        NotifyToast().show(
          context: context,
          child: const InfoNotifyToast(
            title: 'Aplikacja automatycznie zapisuje zmiany',
            body: 'Nie ma potrzeby ręcznego zapisywania zmian,',
          ),
        );
      },
    ),
    MenuItem(
      label: "Usuń",
      icon: Icons.delete,
      onSelected: () => deleteNote(),
    ),
  ];
}
