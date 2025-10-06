import 'package:flutter/material.dart';
import 'package:laza/core/routing/app_router.dart';

void main() {
  runApp(const LazaApp());
}

class LazaApp extends StatelessWidget {
  const LazaApp({super.key});

  @override
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Cairo'),
      routerConfig: RouteGenerator.mainRoutingInOurApp,
    );
  }
}
