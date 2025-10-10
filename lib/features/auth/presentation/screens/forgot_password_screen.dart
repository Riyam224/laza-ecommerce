import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:laza/core/common_ui/widgets/bottom_action_button.dart';
import 'package:laza/core/common_ui/widgets/custom_back_button.dart';
import 'package:laza/core/common_ui/widgets/custom_text_field.dart';
import 'package:laza/core/constants/assets.dart';
import 'package:laza/core/di/di.dart';
import 'package:laza/core/routing/routes.dart';
import 'package:laza/core/utils/theming/app_colors.dart';
import 'package:laza/features/auth/presentation/cubit/forget_password/forgot_password_cubit.dart';
import 'package:laza/features/auth/presentation/cubit/forget_password/forgot_password_state.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<ForgotPasswordCubit>(),
      child: const _ForgotPasswordContent(),
    );
  }
}

class _ForgotPasswordContent extends StatefulWidget {
  const _ForgotPasswordContent();

  @override
  State<_ForgotPasswordContent> createState() => _ForgotPasswordContentState();
}

class _ForgotPasswordContentState extends State<_ForgotPasswordContent> {
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _handleConfirmMail() {
    final email = _emailController.text.trim();

    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter your email address'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    context.read<ForgotPasswordCubit>().sendOtp(email);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ForgotPasswordCubit, ForgotPasswordState>(
      listener: (context, state) {
        if (state is ForgotPasswordSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('OTP sent to your email!'),
              backgroundColor: Colors.green,
            ),
          );
          // Navigate to verification screen with email
          context.push('${AppRoutes.verificationCode}?email=${state.email}');
        } else if (state is ForgotPasswordError) {
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

        // 💜 Bottom "Confirm Mail" button
        bottomNavigationBar: BlocBuilder<ForgotPasswordCubit, ForgotPasswordState>(
          builder: (context, state) {
            final isLoading = state is ForgotPasswordLoading;
            return BottomActionButton(
              text: isLoading ? 'Sending...' : 'Confirm Mail',
              onPressed: isLoading ? () {} : _handleConfirmMail,
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
                CustomTextField(
                  label: "Email Address",
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  hintText: "Enter your email",
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
      ),
    );
  }
}
