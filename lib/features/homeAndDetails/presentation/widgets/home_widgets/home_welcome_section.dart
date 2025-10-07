// widgets/welcome_section.dart
import 'package:flutter/material.dart';

class WelcomeSection extends StatelessWidget {
  const WelcomeSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Hello',
            style: TextStyle(
              color: const Color(0xFF1D1E20),
              fontSize: 28,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w600,
              height: 1.10,
              letterSpacing: -0.21,
            ),
          ),
          SizedBox(height: 5),
          Text(
            'Welcome to Laza.',
            style: TextStyle(
              color: const Color(0xFF8F959E),
              fontSize: 15,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w400,
              height: 1.10,
            ),
          ),
          SizedBox(height: 24),
        ],
      ),
    );
  }
}
