import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:laza/core/common_ui/widgets/bottom_action_button.dart';
import 'package:laza/core/common_ui/widgets/custom_back_button.dart';
import 'package:laza/core/common_ui/widgets/custom_text_field.dart';
import 'package:laza/core/routing/routes.dart';
import 'package:laza/core/utils/theming/app_colors.dart';
import 'package:laza/core/error/auth_error_msg.dart';
import 'package:laza/features/auth/presentation/cubit/register_cubit.dart';
import 'package:laza/features/auth/presentation/cubit/register_state.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  bool rememberMe = false;
  bool _obscurePassword = true;
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  String _getPasswordStrength() {
    final password = _passwordController.text;
    if (password.isEmpty) return '';

    int strength = 0;
    if (password.length >= 8) strength++;
    if (password.contains(RegExp(r'[A-Z]'))) strength++;
    if (password.contains(RegExp(r'[0-9]'))) strength++;
    if (password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) strength++;

    if (strength <= 1) return 'Weak';
    if (strength == 2) return 'Fair';
    if (strength == 3) return 'Good';
    return 'Strong';
  }

  Color _getPasswordStrengthColor() {
    final strength = _getPasswordStrength();
    switch (strength) {
      case 'Weak':
        return Colors.red;
      case 'Fair':
        return Colors.orange;
      case 'Good':
        return Colors.blue;
      case 'Strong':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RegisterCubit, RegisterState>(
      listener: (context, state) {
        if (state is RegisterSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(ErrorMessages.registrationSuccess),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 2),
            ),
          );

          // Navigate to login page after a short delay
          Future.delayed(const Duration(seconds: 2), () {
            if (context.mounted) {
              context.go(AppRoutes.login);
            }
          });
        } else if (state is RegisterError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 4),
              action: SnackBarAction(
                label: 'Dismiss',
                textColor: Colors.white,
                onPressed: () {},
              ),
            ),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.white,

          //  Sign Up button at bottom
          bottomNavigationBar: BottomActionButton(
            text: state is RegisterLoading ? "Loading..." : "Sign Up",
            backgroundColor: AppColors.primaryColor,
            textColor: Colors.white,
            onPressed: state is RegisterLoading
                ? () {}
                : () {
                    final username = _usernameController.text.trim();
                    final email = _emailController.text.trim();
                    final password = _passwordController.text.trim();

                    // Validate username
                    final usernameError = ErrorMessages.validateUsername(
                      username,
                    );
                    if (usernameError != null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(usernameError),
                          backgroundColor: Colors.red,
                        ),
                      );
                      return;
                    }

                    // Validate email
                    final emailError = ErrorMessages.validateEmail(email);
                    if (emailError != null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(emailError),
                          backgroundColor: Colors.red,
                        ),
                      );
                      return;
                    }

                    // Validate password
                    final passwordError = ErrorMessages.validatePassword(
                      password,
                    );
                    if (passwordError != null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(passwordError),
                          backgroundColor: Colors.red,
                        ),
                      );
                      return;
                    }

                    context.read<RegisterCubit>().registerUser(
                      email: email,
                      username: username,
                      password: password,
                    );
                  },
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
                        color: Color(0xFF1D1E20),
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
                  CustomTextField(
                    label: "Username",
                    controller: _usernameController,
                    suffix: Icon(Icons.check, color: Colors.green, size: 20),
                  ),
                  const SizedBox(height: 20),

                  // 🔒 Password
                  Row(
                    children: [
                      Expanded(
                        child: CustomTextField(
                          label: "Password",
                          controller: _passwordController,
                          obscureText: _obscurePassword,
                          onChanged: (_) =>
                              setState(() {}), // Update strength indicator
                          suffix: IconButton(
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: Colors.grey,
                              size: 20,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      if (_passwordController.text.isNotEmpty)
                        Text(
                          _getPasswordStrength(),
                          style: TextStyle(
                            color: _getPasswordStrengthColor(),
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // 📧 Email
                  CustomTextField(
                    label: "Email Address",
                    controller: _emailController,
                    suffix: const Icon(
                      Icons.check,
                      color: Colors.green,
                      size: 20,
                    ),
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
                          activeThumbColor: Colors.white,
                          activeTrackColor: const Color(
                            0xFF34C759,
                          ), // iOS green
                          inactiveThumbColor: Colors.white,
                          inactiveTrackColor: const Color(0xFFE5E5E5),
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                        ),
                      ),
                    ],
                  ),

                  // todo
                  const SizedBox(height: 40),

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
                  const SizedBox(height: 20),

                  // 📝 Sign Up Link
                  Center(
                    child: GestureDetector(
                      onTap: () => context.push(AppRoutes.login),
                      child: RichText(
                        text: const TextSpan(
                          text: "Already have an account? ",
                          style: TextStyle(color: Colors.grey, fontSize: 15),
                          children: [
                            TextSpan(
                              text: "Sign in",
                              style: TextStyle(
                                color: Colors.black,
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
      },
    );
  }
}
