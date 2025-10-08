import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:laza/core/common_ui/widgets/bottom_navigation.dart';
import 'package:laza/core/common_ui/widgets/custom_drawer.dart';
import 'package:laza/core/di.dart';
import 'package:laza/core/theming/app_colors.dart';
import 'package:laza/features/home/presentation/cubit/product_cubit/product_cubit.dart';
import 'package:laza/features/home/presentation/cubit/product_cubit/product_state.dart';
import 'package:laza/features/home/presentation/widgets/home_widgets/home_brand_section.dart';
import 'package:laza/features/home/presentation/widgets/home_widgets/home_custom_header.dart';
import 'package:laza/features/home/presentation/widgets/home_widgets/home_products_section.dart';
import 'package:laza/features/home/presentation/widgets/home_widgets/home_search_bar_widget.dart';
import 'package:laza/features/home/presentation/widgets/home_widgets/home_welcome_section.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<ProductCubit>()..getProducts(),
      child: Scaffold(
        drawer: const CustomDrawer(),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CustomHeader(bgColor: AppColors.iconsBg),
                const SizedBox(height: 16),
                const WelcomeSection(),
                const SearchBarWidget(),
                const BrandSection(),
                BlocBuilder<ProductCubit, ProductState>(
                  builder: (context, state) {
                    if (state is ProductLoading) {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.all(20.0),
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }

                    if (state is ProductError) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            children: [
                              Text(
                                state.message,
                                style: const TextStyle(color: Colors.red),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 16),
                              ElevatedButton(
                                onPressed: () {
                                  context.read<ProductCubit>().getProducts();
                                },
                                child: const Text('Retry'),
                              ),
                            ],
                          ),
                        ),
                      );
                    }

                    if (state is ProductLoaded) {
                      return ProductsSection(
                        title: 'New Arrival',
                        products: state.products,
                      );
                    }

                    return const SizedBox.shrink();
                  },
                ),
                const SizedBox(height: 80),
              ],
            ),
          ),
        ),
        bottomNavigationBar: const BottomNavWidget(),
      ),
    );
  }
}
