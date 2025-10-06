import 'package:flutter/material.dart';
import 'package:laza/core/common_ui/widgets/bottom_action_button.dart';
import 'package:laza/core/common_ui/widgets/custom_back_button.dart';
import 'package:laza/core/common_ui/widgets/custom_text_field.dart';
import 'package:laza/core/theming/app_colors.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool rememberMe = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      // 💜 Bottom "Login" button
      bottomNavigationBar: BottomActionButton(
        text: "Login",
        backgroundColor: AppColors.primaryColor,
        textColor: Colors.white,
        // todo login
        onPressed: () {},
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🔙 Back Button
              const SizedBox(height: 12),
              CustomBackButton(onPressed: () => Navigator.pop(context)),
              const SizedBox(height: 20),

              // ✨ Welcome Text
              const Center(
                child: Column(
                  children: [
                    Text(
                      "Welcome",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      'Please enter your data to continue',
                      style: TextStyle(
                        color: Color(0xFF8F959E),
                        fontSize: 15,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400,
                        height: 1.10,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 164),

              // 👤 Username
              const CustomTextField(
                label: "Username",
                // value: "Esther Howard",
                suffix: Icon(Icons.check, color: Colors.green, size: 20),
              ),
              const SizedBox(height: 20),

              // 🔒 Password + Forgot password
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Expanded(
                    child: CustomTextField(
                      label: "Password",
                      // value: "HJ@#9783kja",
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: const [
                      SizedBox(height: 5),
                      Text(
                        "Strong",
                        style: TextStyle(color: Colors.green, fontSize: 13),
                      ),
                      SizedBox(height: 6),
                      Text(
                        "Forgot password?",
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 13.5,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // 🟢 Remember Me Toggle
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
                    scale: 0.9,
                    child: Switch(
                      value: rememberMe,
                      onChanged: (val) => setState(() => rememberMe = val),
                      activeColor: Colors.white,
                      activeTrackColor: const Color(0xFF34C759),
                      inactiveThumbColor: Colors.white,
                      inactiveTrackColor: const Color(0xFFE5E5E5),
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 109),

              // 📄 Terms & Condition
              const Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Text.rich(
                    TextSpan(
                      text:
                          "By connecting your account confirm that you agree with our ",
                      style: TextStyle(color: Colors.grey, fontSize: 13.5),
                      children: [
                        TextSpan(
                          text: "Term and Condition",
                          style: TextStyle(
                            color: Colors.black87,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
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
