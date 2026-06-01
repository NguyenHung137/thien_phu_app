import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class StatCounter extends StatelessWidget {
  final String value;
  final String label;

  const StatCounter({
    super.key,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: GoogleFonts.beVietnamPro(
            fontSize: 24,
            fontWeight: FontWeight.w900,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          textAlign: TextAlign.center,
          style: GoogleFonts.beVietnamPro(
            fontSize: 10,
            color: Colors.white70,
            height: 1.3,
          ),
        ),
      ],
    );
  }
}
