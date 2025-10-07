import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:laza/core/common_ui/widgets/bottom_action_button.dart';
import 'package:laza/core/common_ui/widgets/custom_icon_with_bg.dart';
import 'package:laza/core/constants/assets.dart';
import 'package:laza/core/theming/app_colors.dart';

class AddNewCardScreen extends StatefulWidget {
  const AddNewCardScreen({super.key});

  @override
  State<AddNewCardScreen> createState() => _AddNewCardScreenState();
}

class _AddNewCardScreenState extends State<AddNewCardScreen> {
  int selectedIndex = 0;

  final List<Map<String, dynamic>> paymentMethods = [
    {'icon': Assets.resourceImagesMasterIcon, 'name': 'MasterCard'},
    {'icon': Assets.resourceImagesPaypalIcon, 'name': 'PayPal'},
    {'icon': Assets.resourceImagesCreditIcon, 'name': 'Bank'},
  ];

  final _ownerController = TextEditingController(text: 'Mrh Raju');
  final _cardNumberController = TextEditingController(
    text: '5254 7634 8734 7690',
  );
  final _expController = TextEditingController(text: '24/24');
  final _cvvController = TextEditingController(text: '7763');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🔙 Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomIconWithBg(
                    iconImg: Assets.resourceImagesArrowLeft,
                    backgroundColor: AppColors.iconsBg,
                    onTap: () {
                      GoRouter.of(context).go('/payment');
                    },
                  ),
                  const Text(
                    'Add New Card',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(width: 45),
                ],
              ),
              const SizedBox(height: 24),

              // 💳 Payment Type Selector
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(paymentMethods.length, (index) {
                  final method = paymentMethods[index];
                  final bool isSelected = selectedIndex == index;

                  return GestureDetector(
                    onTap: () => setState(() => selectedIndex = index),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 95,
                      height: 60,
                      decoration: BoxDecoration(
                        color: isSelected
                            ? const Color(0xFFFFF6F2)
                            : const Color(0xFFF6F7FB),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected
                              ? const Color(0xFFFF6F00)
                              : Colors.transparent,
                          width: 1.5,
                        ),
                      ),
                      child: Center(
                        child: Image.asset(
                          method['icon'],
                          width: 40,
                          height: 28,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 30),

              // 🔤 Fields
              _buildLabel('Card Owner'),
              _buildTextField(_ownerController, hint: 'Mrh Raju'),
              const SizedBox(height: 16),

              _buildLabel('Card Number'),
              _buildTextField(
                _cardNumberController,
                hint: 'Card Number',
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLabel('EXP'),
                        _buildTextField(_expController, hint: 'MM/YY'),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLabel('CVV'),
                        _buildTextField(_cvvController, hint: '****'),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 80),
            ],
          ),
        ),
      ),

      // 🟣 Bottom Button
      bottomNavigationBar: BottomActionButton(
        text: 'save Card',
        onPressed: () {
          GoRouter.of(context).go('/orderConfirmed');
        },
        backgroundColor: AppColors.primaryColor,
      ),
    );
  }

  // 🧩 Reusable widgets
  Widget _buildLabel(String text) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Text(
      text,
      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
    ),
  );

  Widget _buildTextField(
    TextEditingController controller, {
    required String hint,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      style: const TextStyle(fontSize: 16, color: Colors.black),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.grey),
        filled: true,
        fillColor: const Color(0xFFF6F7FB),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
