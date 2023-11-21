import 'package:flutter/material.dart';

enum SearchResultType { catalog, note, other, tag }

class SearchResult {
  final String id;
  final String title;
  final SearchResultType type;
  final VoidCallback? onTap;

  const SearchResult({
    required this.id,
    required this.title,
    required this.type,
    this.onTap,
  });
}
