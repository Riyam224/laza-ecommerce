import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:laza/core/constants/assets.dart';
import 'package:laza/core/routing/routes.dart';
import '../widgets/gender_button.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFB1A5E1), // soft violet
              Color(0xFF9181D4), // mid tone
              Color(0xFFA394DE), // light violet
              Color(0xFFBDB3E6), // pale lavender
            ],
            stops: [0.0, 0.4, 0.7, 1.0],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(height: 60),

            // 👕 Image section
            Expanded(
              child: Image.asset(
                Assets.resourceImagesOnboarding,
                fit: BoxFit.contain,
              ),
            ),

            // 🧾 Bottom card section
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "Look Good, Feel Good",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Create your individual & unique style and look amazing everyday.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Gender buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      GenderButton(text: 'Men', isSelected: false),
                      SizedBox(width: 12),
                      GenderButton(text: 'Women', isSelected: true),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Skip button
                  TextButton(
                    onPressed: () {
                      GoRouter.of(context).go(AppRoutes.loginOptions);
                    },
                    child: const Text(
                      "Skip",
                      style: TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
