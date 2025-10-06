import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:laza/core/common_ui/widgets/bottom_action_button.dart';
import 'package:laza/core/common_ui/widgets/custom_back_button.dart';
import 'package:laza/core/constants/assets.dart';
import 'package:laza/core/di.dart';
import 'package:laza/core/routing/routes.dart';
import 'package:laza/core/theming/app_colors.dart';
import 'package:laza/features/auth/presentation/cubit/forgot_password_cubit.dart';
import 'package:laza/features/auth/presentation/cubit/forgot_password_state.dart';

class VerificationCodeScreen extends StatelessWidget {
  final String? email;

  const VerificationCodeScreen({super.key, this.email});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<ForgotPasswordCubit>(),
      child: _VerificationCodeContent(email: email ?? ''),
    );
  }
}

class _VerificationCodeContent extends StatefulWidget {
  final String email;

  const _VerificationCodeContent({required this.email});

  @override
  State<_VerificationCodeContent> createState() => _VerificationCodeContentState();
}

class _VerificationCodeContentState extends State<_VerificationCodeContent> {
  final List<TextEditingController> _controllers = List.generate(
    6,
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

  void _handleConfirmCode() {
    final otp = _controllers.map((c) => c.text).join();

    if (otp.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter the 6-digit code'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    context.read<ForgotPasswordCubit>().verifyOtp(widget.email, otp);
  }

  Widget _buildOtpBox(int index) {
    return SizedBox(
      width: 50,
      height: 65,
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
          if (value.isNotEmpty && index < 5) {
            FocusScope.of(context).nextFocus();
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ForgotPasswordCubit, ForgotPasswordState>(
      listener: (context, state) {
        if (state is OtpVerificationSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('OTP verified successfully!'),
              backgroundColor: Colors.green,
            ),
          );
          // Navigate to new password screen with email and otp
          context.push('${AppRoutes.newPassword}?email=${state.email}&otp=${state.otp}');
        } else if (state is OtpVerificationError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,

        // 💜 Bottom "Confirm Code" button
        bottomNavigationBar: BlocBuilder<ForgotPasswordCubit, ForgotPasswordState>(
          builder: (context, state) {
            final isLoading = state is OtpVerificationLoading;
            return BottomActionButton(
              text: isLoading ? 'Verifying...' : 'Confirm Code',
              onPressed: isLoading ? () {} : _handleConfirmCode,
              backgroundColor: AppColors.primaryColor,
              textColor: Colors.white,
            );
          },
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
                      color: Color(0xFF1D1E20),
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
                  children: List.generate(6, (index) => _buildOtpBox(index)),
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
                              : "00:00",
                          style: const TextStyle(
                            color: Color(0xFF1D1E20),
                            fontSize: 13,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w500,
                            height: 1.40,
                          ),
                        ),
                        const TextSpan(
                          text: " resend confirmation code.",
                          style: TextStyle(
                            color: Color(0xFF8F959E),
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
