import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:file_selector/file_selector.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:markdownnotepad/core/app_theme_extension.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';

class SaveFileHelper {
  static Future<PermissionStatus> getDevicePermissions() async {
    if (!Platform.isAndroid) return PermissionStatus.granted;

    final DeviceInfoPlugin plugin = DeviceInfoPlugin();
    final AndroidDeviceInfo android = await plugin.androidInfo;

    final storageStatus = android.version.sdkInt < 33
        ? await Permission.storage.request()
        : PermissionStatus.granted;

    if (storageStatus == PermissionStatus.permanentlyDenied) {
      openAppSettings();
    }

    return storageStatus;
  }

  static Future<void> saveTextFile(
    BuildContext context,
    String fileName,
    String content,
  ) async {
    if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) {
      final PermissionStatus status = await getDevicePermissions();
      if (status != PermissionStatus.granted) return;

      String directoryPath = "/storage/emulated/0/Download";
      if (Platform.isIOS) {
        directoryPath = (await getApplicationDocumentsDirectory()).path;
      }

      if (!kIsWeb) {
        final File file = File('$directoryPath/$fileName');
        if (await file.exists()) {
          await file.delete();
        }
      }
      await File('$directoryPath/$fileName').writeAsString(content);
      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Theme.of(context)
              .extension<MarkdownNotepadTheme>()
              ?.drawerBackground!,
          content: Text(
            "Plik został zapisany w folderze Download",
            style: TextStyle(
              color: Theme.of(context).extension<MarkdownNotepadTheme>()?.text!,
            ),
          ),
          duration: const Duration(seconds: 2),
        ),
      );
    }

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
