import 'dart:convert';

import 'package:dart_eval/dart_eval.dart';
import 'package:dart_eval/dart_eval_bridge.dart';
import 'package:dart_eval/dart_eval_security.dart';
import 'package:dart_eval/stdlib/core.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_eval/flutter_eval.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:markdownnotepad/helpers/snake_case_converter.dart';
import 'package:markdownnotepad/viewmodels/extension.dart';
import 'package:markdownnotepad/viewmodels/imported_extensions.dart';
import 'package:markdownnotepad/viewmodels/load_extension.dart';

enum MDNExtensionUniqueness {
  newExtension,
  editableExtension,
  nonModified,
  notUnique
}

class ExtensionsHelper {
  static Future<MDNLoadExtension?> loadExtension() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['json'],
        allowMultiple: false,
        withData: true,
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

  static bool compileExtensionWidget(
    String extensionName,
    String extensionContent,
  ) {
    Runtime runtime;
    Widget? widget;

    final compiler = Compiler();
    compiler.addPlugin(flutterEvalPlugin);

    try {
      final program = compiler.compile({
        'mdn_extension_$extensionName': {
          'main.dart': extensionContent,
        }
      });

      runtime = Runtime.ofProgram(program);
      runtime.grant(NetworkPermission.any);
      runtime.addPlugin(flutterEvalPlugin);

      widget = (runtime.executeLib(
        'package:mdn_extension_$extensionName/main.dart',
        'MDNExtension.',
        [$String('')],
      ) as $Value)
          .$value;
    } catch (e) {
      debugPrint(e.toString());
    }

    return widget != null;
  }

  static bool validateLoadExtension(MDNLoadExtension extension) {
    if (extension.content.isEmpty ||
        extension.title.isEmpty ||
        extension.author.isEmpty ||
        extension.version.isEmpty ||
        extension.activator.isEmpty) return false;

    return compileExtensionWidget(
      SnakeCaseConverter.convert(extension.title),
      extension.content,
    );
  }

  static bool validateExtension(MDNExtension extension) {
    if (extension.content.isEmpty ||
        extension.title.isEmpty ||
        extension.author.isEmpty ||
        extension.version.isEmpty ||
        extension.activator.isEmpty) return false;

    return compileExtensionWidget(
      SnakeCaseConverter.convert(extension.title),
      extension.content,
    );
  }

  static Future<MDNExtensionUniqueness> checkExtensionUniqueness(
    MDNExtension extension,
  ) async {
    final Box importedExtensionsBox = Hive.box<ImportedExtensions>(
      'imported_extensions',
    );
    final ImportedExtensions importedExtensions = importedExtensionsBox.get(
      'imported_extensions',
      defaultValue: ImportedExtensions(
        extensions: [],
      ),
    );

    MDNExtensionUniqueness uniqueness = MDNExtensionUniqueness.newExtension;

    for (var ext in importedExtensions.extensions) {
      if (ext.title == extension.title) {
        if (ext.author == extension.author &&
            ext.activator == extension.activator) {
          uniqueness = MDNExtensionUniqueness.editableExtension;
          if (ext == extension) uniqueness = MDNExtensionUniqueness.nonModified;
        } else {
          uniqueness = MDNExtensionUniqueness.notUnique;
        }
        break;
      } else if (ext.activator == extension.activator) {
        uniqueness = MDNExtensionUniqueness.notUnique;
        break;
      }
    }

    return uniqueness;
  }

  static Future<bool> saveExtension(MDNExtension extension) async {
    final Box importedExtensionsBox = Hive.box<ImportedExtensions>(
      'imported_extensions',
    );
    final ImportedExtensions importedExtensions = importedExtensionsBox.get(
      'imported_extensions',
      defaultValue: ImportedExtensions(
        extensions: [],
      ),
    );

    try {
      importedExtensions.extensions.add(extension);
      await importedExtensions.save();

      return true;
    } catch (e) {
      debugPrint(e.toString());
    }
    return false;
  }

  static Future<bool> patchExtension(MDNExtension extension) async {
    final Box importedExtensionsBox = Hive.box<ImportedExtensions>(
      'imported_extensions',
    );
    final ImportedExtensions importedExtensions = importedExtensionsBox.get(
      'imported_extensions',
      defaultValue: ImportedExtensions(
        extensions: [],
      ),
    );
    try {
      for (int i = 0; i < importedExtensions.extensions.length; i++) {
        if (importedExtensions.extensions[i].title == extension.title) {
          importedExtensions.extensions[i] = extension;
        }
      }
      await importedExtensions.save();

      return true;
    } catch (e) {
      debugPrint(e.toString());
    }
    return false;
  }

  static Future<bool> removeExtension(MDNExtension extension) async {
    final Box importedExtensionsBox = Hive.box<ImportedExtensions>(
      'imported_extensions',
    );
    ImportedExtensions importedExtensions = importedExtensionsBox.get(
      'imported_extensions',
      defaultValue: ImportedExtensions(
        extensions: [],
      ),
    );
    try {
      final int lengthBefore = importedExtensions.extensions.length;

      importedExtensions.extensions
          .removeWhere((ext) => ext.title == extension.title);
      await importedExtensions.save();

      return lengthBefore != importedExtensions.extensions.length;
    } catch (e) {
      debugPrint(e.toString());
    }
    return false;
  }

  static Future<bool> disableExtension(MDNExtension extension) async {
    final MDNExtension newExt = MDNExtension.fromJson(
      {
        ...extension.toJson(),
        "status": "inactive",
      },
    );
    return patchExtension(newExt);
  }

  static Future<bool> enableExtension(MDNExtension extension) async {
    final MDNExtension newExt = MDNExtension.fromJson(
      {
        ...extension.toJson(),
        "status": "active",
      },
    );
    return patchExtension(newExt);
  }
}
