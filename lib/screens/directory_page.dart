import 'package:flutter/material.dart';

class DirectoryPage extends StatelessWidget {
  final String directoryId;

  const DirectoryPage({
    super.key,
    required this.directoryId,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      "Folder: $directoryId",
      textAlign: TextAlign.center,
    );
  }
}
