import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:laza/core/di.dart';
import 'package:laza/core/routing/routes.dart';
import 'package:laza/features/auth/presentation/cubit/register_cubit.dart';
import 'package:laza/features/auth/presentation/screens/forgot_password_screen.dart';
import 'package:laza/features/auth/presentation/screens/login_options_screen.dart';
import 'package:laza/features/auth/presentation/screens/login_screen.dart';
import 'package:laza/features/auth/presentation/screens/new_password_screen.dart';
import 'package:laza/features/auth/presentation/screens/signup_screen.dart';
import 'package:laza/features/auth/presentation/screens/verification_code_screen.dart';
import 'package:laza/features/home/presentation/screens/home_screen.dart';
import 'package:laza/features/onboarding/presentation/screens/onboarding_screen.dart';
import 'package:laza/features/splash/presentation/screens/splash_screen.dart';

class RouteGenerator {
  static GoRouter mainRoutingInOurApp = GoRouter(
    errorBuilder: (context, state) =>
        const Scaffold(body: Center(child: Text('404 Not Found'))),
    // todo initial route
    initialLocation: AppRoutes.forgetPassword,
    routes: [
      // GoRoute(
      //   path: AppRoutes.root,
      //   name: AppRoutes.root,
      //   builder: (context, state) => const MainLayout(),
      // ),
      GoRoute(
        path: AppRoutes.splash,
        name: AppRoutes.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: AppRoutes.onboarding,
        name: AppRoutes.onboarding,
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: AppRoutes.loginOptions,
        name: AppRoutes.loginOptions,
        builder: (context, state) => const LoginOptionsScreen(),
      ),
      GoRoute(
        path: AppRoutes.login,
        name: AppRoutes.login,
        builder: (context, state) => const LoginScreen(),
      ),

      GoRoute(
        path: AppRoutes.signup,
        name: AppRoutes.signup,
        builder: (context, state) => BlocProvider(
          create: (context) => sl<RegisterCubit>(),
          child: const SignupScreen(),
        ),
      ),

      GoRoute(
        path: AppRoutes.forgetPassword,
        name: AppRoutes.forgetPassword,
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
      GoRoute(
        path: AppRoutes.verificationCode,
        name: AppRoutes.verificationCode,
        builder: (context, state) {
          final email = state.uri.queryParameters['email'];
          return VerificationCodeScreen(email: email);
        },
      ),
      GoRoute(
        path: AppRoutes.newPassword,
        name: AppRoutes.newPassword,
        builder: (context, state) {
          final email = state.uri.queryParameters['email'];
          final otp = state.uri.queryParameters['otp'];
          return NewPasswordScreen(email: email, otp: otp);
        },
      ),

      GoRoute(
        path: AppRoutes.home,
        name: AppRoutes.home,
        builder: (context, state) => const HomeScreen(),
      ),
    ],
  );
}
