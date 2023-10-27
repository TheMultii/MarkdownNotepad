import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:markdownnotepad/helpers/bytes_converter.dart';

class ExtensionsHelper {
  static void loadExtension() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['dart'],
        allowMultiple: false,
      );

      if (result == null) {
        debugPrint("User canceled the file picker");
        return;
      }

      PlatformFile file = result.files.first;
      debugPrint("File Name: ${file.name}");
      debugPrint(
        "File Size: ${file.size} bytes | ${BytesConverter.bytesToSize(file.size)}",
      );
      debugPrint("File Path: ${file.path}");
    } catch (e) {
      debugPrint("Error picking the file: $e");
    }
  }
}
