import 'package:flutter/material.dart';
import 'package:flutter_context_menu/flutter_context_menu.dart';
import 'package:markdownnotepad/components/notifications/info_notify_toast.dart';
import 'package:markdownnotepad/core/notify_toast.dart';
import 'package:markdownnotepad/helpers/save_file_helper.dart';

List<ContextMenuEntry> getEditorContextMenu({
  required BuildContext context,
  required String noteID,
  required String textToRender,
  required bool isLiveShareEnabled,
  required VoidCallback toggleLiveShare,
  required VoidCallback changeNoteName,
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
              "$noteID.md",
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
      onSelected: () {},
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
      onSelected: () {},
    ),
  ];
}
