import 'package:file_selector/file_selector.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class SaveFileHelper {
  static Future<void> saveTextFile(
    BuildContext context,
    String fileName,
    String content,
  ) async {
    final FileSaveLocation? result = await getSaveLocation(
      suggestedName: fileName,
    );
    if (result == null) return;

    final Uint8List fileData = Uint8List.fromList(content.codeUnits);
    final XFile textFile = XFile.fromData(
      fileData,
      mimeType: 'text/markdown',
      name: fileName,
    );
    await textFile.saveTo(result.path);
  }
}
