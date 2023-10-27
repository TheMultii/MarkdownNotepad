import 'package:flutter/material.dart';

class DashboardFavouritesSection extends StatelessWidget {
  const DashboardFavouritesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        "🤔 Nie ma.",
        textAlign: TextAlign.center,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontSize: 32,
        ),
      ),
    );
  }
}
