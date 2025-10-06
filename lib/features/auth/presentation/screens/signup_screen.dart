import 'package:flutter/material.dart';
import 'package:laza/core/common_ui/widgets/bottom_action_button.dart';
import 'package:laza/core/common_ui/widgets/custom_back_button.dart';
import 'package:laza/core/common_ui/widgets/custom_text_field.dart';
import 'package:laza/core/theming/app_colors.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  bool rememberMe = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      // 💜 Sign Up button at bottom
      bottomNavigationBar: BottomActionButton(
        text: "Sign Up",
        backgroundColor: AppColors.primaryColor,
        textColor: Colors.white,
        onPressed: () {},
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🔙 Back button
              const SizedBox(height: 12),
              CustomBackButton(onPressed: () => Navigator.pop(context)),
              const SizedBox(height: 20),
              // todo text fields

              // ✨ Title
              const Center(
                child: Text(
                  'Sign Up',
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
              const SizedBox(height: 100),

              // 👤 Username
              const CustomTextField(
                label: "Username",
                // value: "Esther Howard",
                suffix: Icon(Icons.check, color: Colors.green, size: 20),
              ),
              const SizedBox(height: 20),

              // 🔒 Password
              Row(
                children: const [
                  Expanded(
                    child: CustomTextField(
                      label: "Password",
                      // value: "HJ@#9783kja",
                    ),
                  ),
                  Text(
                    "Strong",
                    style: TextStyle(color: Colors.green, fontSize: 13),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // 📧 Email
              const CustomTextField(
                label: "Email Address",
                // value: "bill.sanders@example.com",
                suffix: Icon(Icons.check, color: Colors.green, size: 20),
              ),
              const SizedBox(height: 42),

              // 🟢 Remember me toggle
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Remember me",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Transform.scale(
                    scale: 0.9, // makes switch smaller like the image
                    child: Switch(
                      value: rememberMe,
                      onChanged: (val) => setState(() => rememberMe = val),
                      activeColor: Colors.white,
                      activeTrackColor: const Color(0xFF34C759), // iOS green
                      inactiveThumbColor: Colors.white,
                      inactiveTrackColor: const Color(0xFFE5E5E5),
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
