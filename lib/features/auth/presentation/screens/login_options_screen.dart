import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:laza/core/common_ui/widgets/bottom_action_button.dart';
import 'package:laza/core/common_ui/widgets/custom_back_button.dart';
import 'package:laza/core/routing/routes.dart';
import 'package:laza/features/auth/presentation/widgets/social_button.dart';

class LoginOptionsScreen extends StatelessWidget {
  const LoginOptionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      // 🟣 Button pinned to bottom
      bottomNavigationBar: BottomActionButton(
        text: "Create an Account",
        onPressed: () {
          GoRouter.of(context).push(AppRoutes.signup);
        },
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),

              // todo  🔙 Back button
              const CustomBackButton(),

              const SizedBox(height: 20),

              // ✨ Title
              const Center(
                child: Text(
                  "Let's Get Started",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              // todo
              const SizedBox(height: 180),

              // 🔵 Facebook Button
              SocialButton(
                color: const Color(0xFF4267B2),
                text: "Facebook",
                imagePath: "assets/images/Facebook.svg",
                onPressed: () {},
              ),
              const SizedBox(height: 16),

              // 🔷 Twitter Button
              SocialButton(
                color: const Color(0xFF1DA1F2),
                text: "Twitter",
                imagePath: "assets/images/Twitter.svg",
                onPressed: () {},
              ),
              const SizedBox(height: 16),

              // 🔴 Google Button
              SocialButton(
                color: const Color(0xFFDB4437),
                text: "Google",
                imagePath: "assets/images/Google.svg",
                onPressed: () {},
              ),
              // todo
              const SizedBox(height: 190),

              // 🧾 Already have an account?
              GestureDetector(
                onTap: () {
                  // Navigate to the login screen
                  GoRouter.of(context).push(AppRoutes.login);
                },
                child: Center(
                  child: RichText(
                    text: const TextSpan(
                      text: "Already have an account? ",
                      style: TextStyle(color: Colors.grey, fontSize: 14),
                      children: [
                        TextSpan(
                          text: "Signin",
                          style: TextStyle(
                            color: Colors.black87,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
