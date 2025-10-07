// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:laza/core/common_ui/widgets/bottom_action_button.dart';
import 'package:laza/core/common_ui/widgets/custom_icon_with_bg.dart';
import 'package:laza/core/constants/assets.dart';
import 'package:laza/core/theming/app_colors.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final List<Map<String, dynamic>> cartItems = [
    {
      'image': Assets.resourceImagesShirt,
      'title': "Men's Tie-Dye T-Shirt\nNike Sportswear",
      'price': 45.0,
      'tax': 4.0,
      'quantity': 1,
    },
    {
      'image': Assets.resourceImagesShirt,
      'title': "Men's Tie-Dye T-Shirt\nNike Sportswear",
      'price': 45.0,
      'tax': 4.0,
      'quantity': 1,
    },
  ];

  int? selectedIndex; // 🔹 Track which item is clicked
  double subtotal = 110;
  double shipping = 10;

  void increaseQuantity(int index) {
    setState(() => cartItems[index]['quantity']++);
  }

  void decreaseQuantity(int index) {
    if (cartItems[index]['quantity'] > 1) {
      setState(() => cartItems[index]['quantity']--);
    }
  }

  @override
  Widget build(BuildContext context) {
    double total = subtotal + shipping;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🔙 Back + Title
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomIconWithBg(
                    iconImg: Assets.resourceImagesArrowLeft,
                    backgroundColor: AppColors.iconsBg,
                    onTap: () {},
                  ),
                  // SizedBox(width: 85),
                  const Text(
                    'Cart',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(width: 45),
                ],
              ),
              const SizedBox(height: 25),

              // 🛍 Cart Items
              Column(
                children: List.generate(cartItems.length, (index) {
                  final item = cartItems[index];
                  final bool isSelected = selectedIndex == index;

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        // If clicked again, unselect it
                        if (selectedIndex == index) {
                          selectedIndex = null;
                        } else {
                          selectedIndex = index;
                        }
                      });
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      margin: const EdgeInsets.only(bottom: 20),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          // 🔥 Highlight shadow when selected
                          BoxShadow(
                            color: isSelected
                                ? AppColors.primaryColor.withOpacity(0.3)
                                : Colors.black.withOpacity(0.05),
                            blurRadius: isSelected ? 20 : 10,
                            offset: const Offset(0, 6),
                          ),
                        ],
                        border: isSelected
                            ? Border.all(
                                color: AppColors.primaryColor.withOpacity(0.6),
                                width: 1.5,
                              )
                            : null,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // 🖼 Product image
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.asset(
                              item['image'],
                              width: 80,
                              height: 100,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(width: 12),

                          // 📄 Info
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item['title'],
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  "\$${item['price']} (-\$${item['tax']} Tax)",
                                  style: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(height: 12),

                                // 🔽🔼 Quantity controls
                                Row(
                                  children: [
                                    _quantityButton(
                                      icon: Icons.keyboard_arrow_down_rounded,
                                      onTap: () => decreaseQuantity(index),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0,
                                      ),
                                      child: Text(
                                        item['quantity'].toString(),
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    _quantityButton(
                                      icon: Icons.keyboard_arrow_up_rounded,
                                      onTap: () => increaseQuantity(index),
                                    ),
                                    const Spacer(),
                                    IconButton(
                                      onPressed: () {},
                                      icon: const Icon(
                                        Icons.delete_outline,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 10),

              // 🚚 Delivery Address
              const Text(
                "Delivery Address",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  height: 2,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Stack(
                      alignment: Alignment.center, // centers the logo on map
                      children: [
                        Image.asset(
                          Assets
                              .resourceImagesLocation, // 🗺️ background map image
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        ),
                        Icon(
                          Icons.location_on,
                          color: const Color.fromARGB(255, 238, 69, 51),
                          size: 24,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Chhatak, Sunamgonj 12/8AB",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          "Sylhet",
                          style: TextStyle(color: Colors.grey, fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.check_circle, color: Colors.green, size: 24),
                ],
              ),
              const SizedBox(height: 25),

              // 💳 Payment Method
              const Text(
                "Payment Method",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  height: 2,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF6F7FB),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Image.asset(Assets.resourceImagesVisa),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Visa Classic",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          "**** 7690",
                          style: TextStyle(color: Colors.grey, fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.check_circle, color: Colors.green, size: 24),
                ],
              ),

              const SizedBox(height: 25),

              // 📦 Order Info
              const Text(
                "Order Info",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  height: 2,
                ),
              ),
              const SizedBox(height: 10),
              _priceRow("Subtotal", "\$${subtotal.toStringAsFixed(0)}"),
              _priceRow("Shipping cost", "\$${shipping.toStringAsFixed(0)}"),
              const Divider(height: 20, thickness: 1),
              _priceRow(
                "Total",
                "\$${total.toStringAsFixed(0)}",
                bold: true,
                color: Colors.black,
              ),
              const SizedBox(height: 80),
            ],
          ),
        ),
      ),

      // 🟣 Checkout Button
      bottomNavigationBar: BottomActionButton(
        text: 'Checkout',
        onPressed: () {},
        backgroundColor: AppColors.primaryColor,
      ),
    );
  }

  // 🔸 Helpers
  Widget _quantityButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: const Color(0xFFF6F7FB),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, size: 22, color: Colors.black),
      ),
    );
  }

  Widget _priceRow(
    String label,
    String value, {
    bool bold = false,
    Color color = Colors.grey,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              color: color,
              fontWeight: bold ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              color: color,
              fontWeight: bold ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
