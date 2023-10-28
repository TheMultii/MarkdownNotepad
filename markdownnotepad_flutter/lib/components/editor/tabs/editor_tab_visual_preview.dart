import 'dart:math';

import 'package:flutter/material.dart';
  final String textToRender;

  const EditorTabVisualPreview({
    super.key,
    required this.textToRender,
  });

class EditorTabVisualPreview extends StatelessWidget {
  const EditorTabVisualPreview({super.key});

  @override
  Widget build(BuildContext context) {
    final id = Random().nextInt(25);

    return Image.network(
      "https://api.mganczarczyk.pl/tairiku/random/streetmoe?safety=true&seed=$id",
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;

        return const Center(
          child: CircularProgressIndicator(),
        );
      },
      fit: BoxFit.cover,
    );
  }
}
