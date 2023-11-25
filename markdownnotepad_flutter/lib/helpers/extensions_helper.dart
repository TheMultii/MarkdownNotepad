import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:markdownnotepad/viewmodels/extension.dart';
import 'package:markdownnotepad/viewmodels/load_extension.dart';

class ExtensionsHelper {
  static Future<MDNLoadExtension?> loadExtension() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['json'],
        allowMultiple: false,
      );

      if (result == null) {
        debugPrint("User canceled the file picker");
        return null;
      }

      PlatformFile file = result.files.first;
      if (file.bytes == null) return null;

      final String fileString = String.fromCharCodes(file.bytes!);
      var decodedJson = jsonDecode(fileString);

      MDNLoadExtension loadedExtension = MDNLoadExtension.fromJson(
        decodedJson,
      );

      return loadedExtension;
    } catch (e) {
      debugPrint("Error picking the file: $e");
    }
    return null;
  }
  }
}
