
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:laza/core/common_ui/widgets/custom_icon_with_bg.dart';
import 'package:laza/core/di/di.dart';
import 'package:laza/core/utils/theming/app_colors.dart';
import 'package:laza/core/constants/assets.dart';
import 'package:laza/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:laza/features/cart/presentation/screen/cart_screen.dart';
import 'package:laza/features/home/presentation/screens/home_screen.dart';
import 'package:laza/features/payment/presentation/screen/add_new_card_screen.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).drawerTheme.backgroundColor,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 45),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomIconWithBg(
                iconImg: Assets.resourceImagesMenuDrawer,
                backgroundColor: AppColors.iconsBg,
                onTap: () async {
                  Navigator.of(context).pop();
                  await Future.delayed(const Duration(milliseconds: 150));
                },
              ),
              const SizedBox(height: 30),

              // 👤 Profile section
              Row(
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundImage: AssetImage(Assets.resourceImagesNezuko),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Nezuko Uzumaki',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).textTheme.bodyLarge?.color,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Row(
                          children: [
                            Text(
                              'Verified Profile',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 13,
                              ),
                            ),
                            SizedBox(width: 4),
                            Icon(Icons.verified, color: Colors.green, size: 16),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF6F7FB),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '3 Orders',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).textTheme.bodyLarge?.color,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 80),

              // 🧭 Menu Items
              _drawerItem(
                context,
                Icons.production_quantity_limits_sharp,
                'products category',
                const HomeScreen(),
              ),
              _drawerItem(
                context,
                Icons.shopping_bag_outlined,
                'Order',
                const HomeScreen(),
              ),
              _drawerItem(
                context,
                Icons.shopping_cart_outlined,
                'Cart',
                const CartScreen(),
              ),
              _drawerItem(
                context,
                Icons.credit_card_outlined,
                'My Cards',
                const AddNewCardScreen(),
              ),
              _drawerItem(
                context,
                Icons.settings_outlined,
                'Settings',
                const HomeScreen(),
              ),

              const Spacer(),

              // 🚪 Logout
              ListTile(
                leading: const Icon(Icons.logout, color: Colors.red),
                title: const Text(
                  'Logout',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  Future.delayed(const Duration(milliseconds: 200), () {
                 
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 🔸 Drawer Item Helper
  Widget _drawerItem(
    BuildContext context,
    IconData icon,
    String title,
    Widget page,
  ) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primaryColor, size: 24),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          color: Theme.of(context).textTheme.bodyLarge?.color,
        ),
      ),
      onTap: () async {
        Navigator.of(context).pop();
        await Future.delayed(const Duration(milliseconds: 200));

        // ✅ If navigating to CartScreen → wrap in BlocProvider
        if (page is CartScreen) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => BlocProvider(
                create: (_) => sl<CartCubit>()..loadCart(),
                child: const CartScreen(),
              ),
            ),
          );
        } else {
          Navigator.push(context, MaterialPageRoute(builder: (_) => page));
        }
      },
      dense: true,
      visualDensity: const VisualDensity(vertical: -2),
    );
  }
}
