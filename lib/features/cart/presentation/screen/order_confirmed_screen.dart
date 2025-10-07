import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:laza/core/common_ui/widgets/bottom_action_button.dart';
import 'package:laza/core/common_ui/widgets/custom_icon_with_bg.dart';
import 'package:laza/core/constants/assets.dart';
import 'package:laza/core/theming/app_colors.dart';

class OrderConfirmedScreen extends StatelessWidget {
  const OrderConfirmedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: BottomActionButton(
        text: 'Continue Shopping',
        onPressed: () {
          GoRouter.of(context).go('/home');
        },
        backgroundColor: AppColors.primaryColor,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // 🔙 Back button
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CustomIconWithBg(
                    iconImg: Assets.resourceImagesArrowLeft,
                    backgroundColor: AppColors.iconsBg,
                    onTap: () {
                      GoRouter.of(context).go('/payment');
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // 🖼 Illustration
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      Assets.resourceImagesOrderConfirm,
                      width: 300,
                      fit: BoxFit.cover,
                    ),
                    const SizedBox(height: 30),

                    // 🏁 Title
                    Text(
                      'Order Confirmed!',
                      style: TextStyle(
                        color: const Color(0xFF1D1E20),
                        fontSize: 28,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w600,
                        height: 1.10,
                      ),
                    ),
                    const SizedBox(height: 10),

                    // ✉️ Subtitle
                    SizedBox(
                      width: 322,
                      child: Text(
                        'Your order has been confirmed, we will send you confirmation email shortly.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: const Color(0xFF8F959E),
                          fontSize: 15,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w400,
                          height: 1.40,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // 🩶 Go to Orders button
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF6F7FB),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text(
                    'Go to Orders',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 14),
            ],
          ),
        ),
      ),
    );
  }
}
