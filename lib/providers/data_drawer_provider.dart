import 'package:flutter/material.dart';

class DataDrawerProvider with ChangeNotifier {
  List<Map<String, dynamic>> _drawerNotesTiles = [
    {
      "name": "Lorem ipsum",
      "icon": Icons.description_outlined,
    },
    {
      "name": "BleBleBle",
      "icon": Icons.description_outlined,
    },
    {
      "name": "Notatka bez tytułu",
      "icon": Icons.description_outlined,
    }
  ];

  List<Map<String, dynamic>> _drawerFolderTiles = [
    {
      "name": "Folder 1",
      "icon": Icons.folder_outlined,
    },
    {
      "name": "Folder 2",
      "icon": Icons.folder_outlined,
    }
  ];

  double _scrollPosition = 0;

  List<Map<String, dynamic>> get drawerNotesTiles => _drawerNotesTiles;
  List<Map<String, dynamic>> get drawerFolderTiles => _drawerFolderTiles;
  double get scrollPosition => _scrollPosition;

  void updateDataDrawer(List<Map<String, dynamic>>? newNotes,
      List<Map<String, dynamic>>? newFolders) async {
    if (newNotes != null) {
      _drawerNotesTiles = newNotes;
    }
    if (newFolders != null) {
      _drawerFolderTiles = newFolders;
    }
    if (newNotes != null || newFolders != null) {
      notifyListeners();
    }
  }

  void setScrollPosition(double newPosition) {
    _scrollPosition = newPosition;
    // nie ma potrzeby notifyListeners() bo nie zmienia się aktualny stan widgetu
    // potrzebne tylko dla przyszłych renderowań
  }
}
