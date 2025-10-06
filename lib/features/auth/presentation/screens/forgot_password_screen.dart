import 'package:flutter/material.dart';
import 'package:laza/core/common_ui/widgets/bottom_action_button.dart';
import 'package:laza/core/common_ui/widgets/custom_back_button.dart';
import 'package:laza/core/common_ui/widgets/custom_text_field.dart';
import 'package:laza/core/constants/assets.dart';
import 'package:laza/core/theming/app_colors.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      // 💜 Bottom "Confirm Mail" button
      bottomNavigationBar: BottomActionButton(
        text: 'Confirm Mail',
        onPressed: () {},
        backgroundColor: AppColors.primaryColor,
        textColor: Colors.white,
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),
              // 🔙 Back button

              // todo  🔙 Back button
              const CustomBackButton(),

              const SizedBox(height: 20),

              // ✨ Title
              const Center(
                child: Text(
                  "Forgot Password",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(height: 40),

              // ☁️ Lock Illustration
              Center(
                child: Image.asset(
                  Assets.resourceImagesForgetPass,
                  height: 200,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 40),

              // 📧 Email input
              const CustomTextField(
                label: "Email Address",
                // value: "bill.sanders@example.com",
              ),
              const SizedBox(height: 180),

              // 📝 Instruction
              const Center(
                child: Text(
                  "Please write your email to receive a\nconfirmation code to set a new password.",
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
