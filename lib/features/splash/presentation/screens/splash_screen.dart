import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:laza/core/constants/assets.dart';
import 'package:laza/core/routing/routes.dart';
import 'package:laza/core/utils/theming/app_colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        context.pushReplacement(AppRoutes.onboarding);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: Center(child: Image.asset(Assets.resourceImagesLogo, width: 66)),
    );
  }
}
