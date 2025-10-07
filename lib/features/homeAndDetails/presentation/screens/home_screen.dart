// home_screen.dart
import 'package:flutter/material.dart';
import 'package:laza/core/common_ui/widgets/bottom_navigation.dart';
import 'package:laza/core/common_ui/widgets/custom_drawer.dart';
import 'package:laza/core/constants/assets.dart';
import 'package:laza/core/theming/app_colors.dart';
import 'package:laza/features/homeAndDetails/presentation/widgets/home_widgets/home_brand_section.dart';

import 'package:laza/features/homeAndDetails/presentation/widgets/home_widgets/home_custom_header.dart';
import 'package:laza/features/homeAndDetails/presentation/widgets/home_widgets/home_products_section.dart';
import 'package:laza/features/homeAndDetails/presentation/widgets/home_widgets/home_search_bar_widget.dart';
import 'package:laza/features/homeAndDetails/presentation/widgets/home_widgets/home_welcome_section.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const CustomDrawer(),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CustomHeader(bgColor: AppColors.iconsBg),
              SizedBox(height: 16),
              const WelcomeSection(),
              const SearchBarWidget(),
              BrandSection(),
              ProductsSection(
                title: 'New Arrival',
                products: [
                  Product(
                    name: 'Nike Sportswear Club Fleece',
                    price: 99,
                    imageUrl: Assets.resourceImagesProduct,
                  ),
                  Product(
                    name: 'Trail Running Jacket Nike Windrunner',
                    price: 99,
                    imageUrl: Assets.resourceImagesProduct,
                  ),
                  Product(
                    name: 'Training Top Nike Dri-FIT',
                    price: 99,
                    imageUrl: Assets.resourceImagesProduct,
                  ),
                  Product(
                    name: 'Nike Therma-FIT',
                    price: 99,
                    imageUrl: Assets.resourceImagesProduct,
                  ),
                ],
              ),
              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const BottomNavWidget(),
    );
  }
}

// widgets/bottom_nav_widget.dart
