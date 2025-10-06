import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:laza/core/common_ui/widgets/bottom_action_button.dart';
import 'package:laza/core/common_ui/widgets/custom_back_button.dart';
import 'package:laza/core/common_ui/widgets/custom_text_field.dart';

class NewPasswordScreen extends StatelessWidget {
  const NewPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      // 💜 Bottom "Reset Password" button
      bottomNavigationBar: BottomActionButton(
        text: 'Reset Password',
        onPressed: () {
          // Navigate to the desired screen when the button is pressed
          GoRouter.of(context).go('/home');
        },
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
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
                  'New Password',
                  style: TextStyle(
                    color: const Color(0xFF1D1E20),
                    fontSize: 28,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w600,
                    height: 1.10,
                    letterSpacing: -0.21,
                  ),
                ),
              ),
              const SizedBox(height: 215),

              // 🔒 Password field
              const CustomTextField(label: "Password"),
              const SizedBox(height: 20),

              // 🔐 Confirm password field
              const CustomTextField(label: "Confirm Password"),
              const SizedBox(height: 180),

              // 📝 Instruction text
              const Center(
                child: Text(
                  "Please write your new password.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                    height: 1.6,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
