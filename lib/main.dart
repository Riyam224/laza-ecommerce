import 'package:flutter/material.dart';
import 'package:laza/core/di.dart';
import 'package:laza/core/routing/app_router.dart';
import 'package:laza/core/theming/app_themes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupDependencies();
  runApp(const LazaApp());
}

class LazaApp extends StatelessWidget {
  const LazaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: AppThemes.lightTheme,
      routerConfig: RouteGenerator.mainRoutingInOurApp,
    );
  }
}
