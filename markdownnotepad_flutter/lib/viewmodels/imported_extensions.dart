import 'package:hive_flutter/hive_flutter.dart';
import 'package:markdownnotepad/viewmodels/extension.dart';

part 'imported_extensions.g.dart';

@HiveType(typeId: 10)
class ImportedExtensions extends HiveObject {
  @HiveField(0)
  List<MDNExtension> extensions;

  ImportedExtensions({
    required this.extensions,
  });
}
