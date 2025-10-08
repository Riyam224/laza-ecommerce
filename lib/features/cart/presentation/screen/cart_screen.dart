import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:laza/core/common_ui/widgets/bottom_action_button.dart';
import 'package:laza/core/common_ui/widgets/custom_icon_with_bg.dart';
import 'package:laza/core/constants/assets.dart';
import 'package:laza/core/theming/app_colors.dart';
import 'package:laza/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:laza/features/cart/presentation/cubit/cart_state.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  int? selectedIndex;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CartCubit>().loadCart();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: BlocBuilder<CartCubit, CartState>(
          builder: (context, state) {
            if (state is CartLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is CartError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Error: ${state.message}',
                      style: const TextStyle(color: Colors.red),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => context.read<CartCubit>().loadCart(),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }

            if (state is! CartLoaded) {
              return const SizedBox();
            }

            final cartItems = state.items;
            final subtotal = state.subtotal;
            final shipping = state.shipping;
            final total = state.total;

            if (cartItems.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.shopping_cart_outlined,
                      size: 100,
                      color: Colors.grey[300],
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Your cart is empty',
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  ],
                ),
              );
            }

            return SingleChildScrollView(
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
                        onTap: () {
                          Navigator.pop(context);
                        },
                      ),
                      const Text(
                        'Cart',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
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
                              BoxShadow(
                                color: isSelected
                                    ? AppColors.primaryColor.withValues(
                                        alpha: 0.3,
                                      )
                                    : Colors.black.withValues(alpha: 0.05),
                                blurRadius: isSelected ? 20 : 10,
                                offset: const Offset(0, 6),
                              ),
                            ],
                            border: isSelected
                                ? Border.all(
                                    color: AppColors.primaryColor.withValues(
                                      alpha: 0.6,
                                    ),
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
                                child: Image.network(
                                  item.productImage,
                                  width: 80,
                                  height: 100,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      width: 80,
                                      height: 100,
                                      color: Colors.grey[200],
                                      child: const Icon(Icons.image),
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(width: 12),

                              // 📄 Info
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.productName,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      "\$${item.price.toStringAsFixed(2)} (-\$${item.tax.toStringAsFixed(2)} Tax)",
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
                                          icon:
                                              Icons.keyboard_arrow_down_rounded,
                                          onTap: () => context
                                              .read<CartCubit>()
                                              .decrementQuantity(item.id),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0,
                                          ),
                                          child: Text(
                                            item.quantity.toString(),
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                        _quantityButton(
                                          icon: Icons.keyboard_arrow_up_rounded,
                                          onTap: () => context
                                              .read<CartCubit>()
                                              .incrementQuantity(item.id),
                                        ),
                                        const Spacer(),
                                        IconButton(
                                          onPressed: () => context
                                              .read<CartCubit>()
                                              .removeItemFromCart(item.id),
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
                          alignment:
                              Alignment.center, // centers the logo on map
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
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(
                        Icons.check_circle,
                        color: Colors.green,
                        size: 24,
                      ),
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
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(
                        Icons.check_circle,
                        color: Colors.green,
                        size: 24,
                      ),
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
                  _priceRow("Subtotal", "\$${subtotal.toStringAsFixed(2)}"),
                  _priceRow(
                    "Shipping cost",
                    "\$${shipping.toStringAsFixed(2)}",
                  ),
                  const Divider(height: 20, thickness: 1),
                  _priceRow(
                    "Total",
                    "\$${total.toStringAsFixed(2)}",
                    bold: true,
                    color: Colors.black,
                  ),
                  const SizedBox(height: 80),
                ],
              ),
            );
          },
        ),
      ),

      // 🟣 Checkout Button
      bottomNavigationBar: BottomActionButton(
        text: 'Checkout',
        onPressed: () {
          GoRouter.of(context).go('/address');
        },
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
