import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:laza/core/common_ui/widgets/bottom_action_button.dart';
import 'package:laza/core/common_ui/widgets/custom_back_button.dart';
import 'package:laza/core/common_ui/widgets/custom_text_field.dart';
import 'package:laza/core/di/di.dart';
import 'package:laza/core/routing/routes.dart';
import 'package:laza/core/utils/theming/app_colors.dart';
import 'package:laza/features/auth/presentation/cubit/forgot_password_cubit.dart';
import 'package:laza/features/auth/presentation/cubit/forgot_password_state.dart';

class NewPasswordScreen extends StatelessWidget {
  final String? email;
  final String? otp;

  const NewPasswordScreen({super.key, this.email, this.otp});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<ForgotPasswordCubit>(),
      child: _NewPasswordContent(email: email ?? '', otp: otp ?? ''),
    );
  }
}

class _NewPasswordContent extends StatefulWidget {
  final String email;
  final String otp;

  const _NewPasswordContent({required this.email, required this.otp});

  @override
  State<_NewPasswordContent> createState() => _NewPasswordContentState();
}

class _NewPasswordContentState extends State<_NewPasswordContent> {
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _handleResetPassword() {
    final password = _passwordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    if (password.isEmpty || confirmPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter both passwords'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Passwords do not match'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (password.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Password must be at least 6 characters'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    context.read<ForgotPasswordCubit>().resetPassword(
          widget.email,
          widget.otp,
          password,
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ForgotPasswordCubit, ForgotPasswordState>(
      listener: (context, state) {
        if (state is ResetPasswordSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Password reset successfully! Please login.'),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 2),
            ),
          );
          // Navigate to login screen
          Future.delayed(const Duration(seconds: 1), () {
            if (context.mounted) {
              context.go(AppRoutes.login);
            }
          });
        } else if (state is ResetPasswordError) {
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

        //  Bottom "Reset Password" button
        bottomNavigationBar: BlocBuilder<ForgotPasswordCubit, ForgotPasswordState>(
          builder: (context, state) {
            final isLoading = state is ResetPasswordLoading;
            return BottomActionButton(
              text: isLoading ? 'Resetting...' : 'Reset Password',
              onPressed: isLoading ? () {} : _handleResetPassword,
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
                    'New Password',
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
                const SizedBox(height: 215),

                // 🔒 Password field
                CustomTextField(
                  label: "Password",
                  controller: _passwordController,
                  obscureText: true,
                  hintText: "Enter new password",
                ),
                const SizedBox(height: 20),

                // 🔐 Confirm password field
                CustomTextField(
                  label: "Confirm Password",
                  controller: _confirmPasswordController,
                  obscureText: true,
                  hintText: "Confirm new password",
                ),
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
      ),
    );
  }
}
