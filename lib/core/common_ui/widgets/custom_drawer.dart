// ignore_for_file: use_build_context_synchronously

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:laza/core/common_ui/widgets/custom_icon_with_bg.dart';
import 'package:laza/core/di/di.dart';
import 'package:laza/core/utils/theming/app_colors.dart';
import 'package:laza/core/constants/assets.dart';
import 'package:laza/core/routing/routes.dart';
import 'package:laza/features/auth/presentation/cubit/user_info/user_info_cubit.dart';
import 'package:laza/features/auth/presentation/cubit/logout/logout_cubit.dart';
import 'package:laza/features/auth/presentation/cubit/logout/logout_state.dart';
import 'package:laza/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:laza/features/cart/presentation/screen/cart_screen.dart';
import 'package:laza/features/home/presentation/screens/home_screen.dart';
import 'package:laza/features/payment/presentation/screen/add_new_card_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({super.key});

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  // todo 🧪 Temporary test function to verify your token and /api/auth/me
  Future<void> testUserInfoApi() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('access_token');
      debugPrint('🪪 [TEST] Token from prefs: $token');

      final dio = Dio(
        BaseOptions(
          baseUrl: 'https://accessories-eshop.runasp.net/api/',
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
      );

      final response = await dio.get('auth/me');
      debugPrint('✅ [TEST] Response: ${response.data}');
    } catch (e) {
      debugPrint('❌ [TEST] Error: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    // Optionally test API automatically when drawer is initialized
    testUserInfoApi();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => sl<UserInfoCubit>()..fetchUserInfo()),
        BlocProvider(create: (context) => sl<LogoutCubit>()),
      ],
      child: BlocListener<LogoutCubit, LogoutState>(
        listener: (context, state) {
          if (state is LogoutSuccess) {
            // Close drawer
            Navigator.of(context).pop();
            // Navigate to login screen
            context.go(AppRoutes.login);
            // Show success message
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Logged out successfully'),
                backgroundColor: Colors.green,
                duration: Duration(seconds: 2),
              ),
            );
          } else if (state is LogoutError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
                duration: const Duration(seconds: 3),
              ),
            );
          }
        },
        child: Drawer(
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

                  /// 👤 Profile Section
                  BlocBuilder<UserInfoCubit, UserInfoState>(
                    builder: (context, state) {
                      if (state is UserInfoLoading) {
                        return const Row(
                          children: [
                            CircleAvatar(
                              radius: 28,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                            SizedBox(width: 12),
                            Expanded(child: Text('Loading...')),
                          ],
                        );
                      }

                      if (state is UserInfoError) {
                        final isAuthError =
                            state.message.toLowerCase().contains(
                              'unauthorized',
                            ) ||
                            state.message.toLowerCase().contains('401') ||
                            state.message.toLowerCase().contains('token');

                        if (isAuthError) {
                          return _guestProfile(context);
                        }

                        return _errorProfile(context, state.message);
                      }

                      if (state is UserInfoSuccess) {
                        final user = state.user;
                        return _userProfile(
                          context,
                          user.fullName,
                          user.email,
                          user.profilePicture,
                        );
                      }

                      return _guestProfile(context);
                    },
                  ),

                  const SizedBox(height: 80),

                  /// 🧭 Drawer Menu Items
                  _drawerItem(
                    context,
                    Icons.production_quantity_limits_sharp,
                    'Products Category',
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

                  /// 🚪 Auth Buttons (Logout / Login)
                  BlocBuilder<UserInfoCubit, UserInfoState>(
                    builder: (context, userState) {
                      final isLoggedIn = userState is UserInfoSuccess;

                      return BlocBuilder<LogoutCubit, LogoutState>(
                        builder: (context, logoutState) {
                          if (isLoggedIn) {
                            // Show Logout button
                            return ListTile(
                              leading: logoutState is LogoutLoading
                                  ? const SizedBox(
                                      width: 24,
                                      height: 24,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                              Colors.red,
                                            ),
                                      ),
                                    )
                                  : const Icon(Icons.logout, color: Colors.red),
                              title: Text(
                                logoutState is LogoutLoading
                                    ? 'Logging out...'
                                    : 'Logout',
                                style: const TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              onTap: logoutState is LogoutLoading
                                  ? null
                                  : () {
                                      context.read<LogoutCubit>().logout();
                                    },
                            );
                          } else {
                            // Show Login button
                            return ListTile(
                              leading: const Icon(
                                Icons.login,
                                color: AppColors.primaryColor,
                              ),
                              title: const Text(
                                'Login',
                                style: TextStyle(
                                  color: AppColors.primaryColor,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              onTap: () {
                                Navigator.of(context).pop();
                                context.go(AppRoutes.login);
                              },
                            );
                          }
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// ✅ User profile layout (fixed overflow issue)
  Widget _userProfile(
    BuildContext context,
    String name,
    String email,
    String? profilePicture,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 28,
          backgroundImage: profilePicture != null
              ? NetworkImage(profilePicture)
              : const AssetImage(Assets.resourceImagesNezuko) as ImageProvider,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                email,
                style: const TextStyle(color: Colors.grey, fontSize: 13),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        const SizedBox(width: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
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
    );
  }

  /// 🧩 Guest user fallback
  Widget _guestProfile(BuildContext context) {
    return Row(
      children: [
        const CircleAvatar(
          radius: 28,
          backgroundImage: AssetImage(Assets.resourceImagesNezuko),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Guest User',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).textTheme.bodyLarge?.color,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Please log in to view profile',
              style: TextStyle(color: Colors.grey, fontSize: 13),
            ),
          ],
        ),
      ],
    );
  }

  /// 🚨 Error message with Retry
  Widget _errorProfile(BuildContext context, String message) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CircleAvatar(
              radius: 28,
              backgroundColor: Colors.red.shade100,
              child: const Icon(
                Icons.error_outline,
                color: Colors.red,
                size: 28,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Failed to load profile\n$message',
                style: const TextStyle(color: Colors.red, fontSize: 13),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ElevatedButton.icon(
          onPressed: () => context.read<UserInfoCubit>().fetchUserInfo(),
          icon: const Icon(Icons.refresh, size: 18),
          label: const Text('Retry'),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryColor,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          ),
        ),
      ],
    );
  }

  /// 📦 Drawer Item Helper
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
