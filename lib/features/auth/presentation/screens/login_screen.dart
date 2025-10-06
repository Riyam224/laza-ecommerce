import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:laza/core/common_ui/widgets/bottom_action_button.dart';
import 'package:laza/core/common_ui/widgets/custom_back_button.dart';
import 'package:laza/core/common_ui/widgets/custom_text_field.dart';
import 'package:laza/core/di.dart';
import 'package:laza/core/routing/routes.dart';
import 'package:laza/core/theming/app_colors.dart';
import 'package:laza/features/auth/presentation/cubit/login_cubit.dart';
import 'package:laza/features/auth/presentation/cubit/login_state.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<LoginCubit>(),
      child: const _LoginScreenContent(),
    );
  }
}

class _LoginScreenContent extends StatefulWidget {
  const _LoginScreenContent();

  @override
  State<_LoginScreenContent> createState() => _LoginScreenContentState();
}

class _LoginScreenContentState extends State<_LoginScreenContent> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool rememberMe = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter email and password'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    context.read<LoginCubit>().loginUser(
          email: email,
          password: password,
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state is LoginSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Login successful!'),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 1),
            ),
          );
          // Navigate to home screen
          context.go(AppRoutes.home);
        } else if (state is LoginError) {
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

        // 💜 Bottom "Login" button
        bottomNavigationBar: BlocBuilder<LoginCubit, LoginState>(
          builder: (context, state) {
            final isLoading = state is LoginLoading;
            return BottomActionButton(
              text: isLoading ? "Loading..." : "Login",
              backgroundColor: AppColors.primaryColor,
              textColor: Colors.white,
              onPressed: isLoading ? () {} : _handleLogin,
            );
          },
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

              // 👤 Email
              CustomTextField(
                label: "Email",
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                hintText: "Enter your email",
              ),
              const SizedBox(height: 20),

              // 🔒 Password + Forgot password
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: CustomTextField(
                      label: "Password",
                      controller: _passwordController,
                      obscureText: true,
                      hintText: "Enter your password",
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const SizedBox(height: 30),
                      GestureDetector(
                        onTap: () => context.push(AppRoutes.forgetPassword),
                        child: const Text(
                          "Forgot password?",
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 13.5,
                            fontWeight: FontWeight.w500,
                          ),
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
                      activeThumbColor: Colors.white,
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
              const SizedBox(height: 20),

              // 📝 Sign Up Link
              Center(
                child: GestureDetector(
                  onTap: () => context.push(AppRoutes.signup),
                  child: RichText(
                    text: const TextSpan(
                      text: "Don't have an account? ",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 15,
                      ),
                      children: [
                        TextSpan(
                          text: "Sign Up",
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
      ),
    );
  }
}
