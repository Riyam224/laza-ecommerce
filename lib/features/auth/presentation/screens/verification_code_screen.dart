import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:laza/core/common_ui/widgets/bottom_action_button.dart';
import 'package:laza/core/common_ui/widgets/custom_back_button.dart';
import 'package:laza/core/constants/assets.dart';
import 'package:laza/core/theming/app_colors.dart';

class VerificationCodeScreen extends StatefulWidget {
  const VerificationCodeScreen({super.key});

  @override
  State<VerificationCodeScreen> createState() => _VerificationCodeScreenState();
}

class _VerificationCodeScreenState extends State<VerificationCodeScreen> {
  final List<TextEditingController> _controllers = List.generate(
    4,
    (index) => TextEditingController(),
  );

  int _secondsRemaining = 20;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _secondsRemaining = 20;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        setState(() => _secondsRemaining--);
      } else {
        _timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    _timer.cancel();
    super.dispose();
  }

  Widget _buildOtpBox(int index) {
    return SizedBox(
      width: 65,
      height: 75,
      child: TextField(
        controller: _controllers[index],
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        maxLength: 1,
        style: const TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.w500,
          color: Colors.black,
        ),
        decoration: InputDecoration(
          counterText: "",
          filled: true,
          fillColor: Colors.grey.shade50,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFE5E5E5)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: AppColors.secondaryColor, width: 1.5),
          ),
        ),
        onChanged: (value) {
          if (value.isNotEmpty && index < 3) {
            FocusScope.of(context).nextFocus();
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      // 💜 Bottom "Confirm Code" button
      bottomNavigationBar: BottomActionButton(
        text: 'Confirm Code',
        onPressed: () {
          GoRouter.of(context).go('/newPassword');
        },
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
              const CustomBackButton(),
              const SizedBox(height: 20),

              // ✨ Title
              const Center(
                child: Text(
                  'Verification Code',
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
              // ☁️ Lock Illustration
              Center(
                child: Image.asset(
                  Assets.resourceImagesForgetPass,
                  height: 200,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 40),

              // 🔢 OTP Boxes
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(4, (index) => _buildOtpBox(index)),
              ),
              const SizedBox(height: 250),

              // ⏱ Timer + Resend
              Center(
                child: RichText(
                  text: TextSpan(
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                    children: [
                      TextSpan(
                        text: _secondsRemaining > 0
                            ? "00:${_secondsRemaining.toString().padLeft(2, '0')}"
                            : "",
                        style: TextStyle(
                          color: const Color(0xFF1D1E20),
                          fontSize: 13,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w500,
                          height: 1.40,
                        ),
                      ),
                      const TextSpan(text: "00:20"),
                      TextSpan(
                        text: " resend confirmation code.",
                        style: TextStyle(
                          color: const Color(0xFF8F959E),
                          fontSize: 13,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w400,
                          height: 1.40,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // const SizedBox(height: 60),
            ],
          ),
        ),
      ),
    );
  }
}
