import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MDNDrawerHeader extends StatelessWidget {
  const MDNDrawerHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        children: [
          Image.asset(
            "assets/icon.png",
            width: 56,
            height: 56,
            fit: BoxFit.cover,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              "MDN Editor",
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.plusJakartaSans().copyWith(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
