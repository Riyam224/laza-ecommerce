// screens/product_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:laza/core/common_ui/widgets/bottom_action_button.dart';

import 'package:laza/core/common_ui/widgets/custom_icon_with_bg.dart';
import 'package:laza/core/constants/assets.dart';
import 'package:laza/core/theming/app_colors.dart';
import 'package:laza/features/home/presentation/widgets/details_widgets/product_details.dart';
import 'package:laza/features/home/presentation/widgets/details_widgets/product_details_size_selector.dart';
import 'package:laza/features/home/presentation/widgets/details_widgets/product_details_total_price.dart';
import 'package:laza/features/home/presentation/widgets/details_widgets/product_image_thumbnail.dart';
import 'package:laza/features/home/presentation/widgets/details_widgets/product_info.dart';
import 'package:laza/features/home/presentation/widgets/details_widgets/review_section.dart';

class ProductDetailScreen extends StatefulWidget {
  const ProductDetailScreen({super.key});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  String selectedSize = 'M';

  int selectedImageIndex = 0;

  final List<String> productImages = [
    Assets.resourceImagesProduct,
    Assets.resourceImagesProduct,
    Assets.resourceImagesProduct,
    Assets.resourceImagesProduct,
  ];

  final List<String> sizes = ['S', 'M', 'L', 'XL', '2XL'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      bottomNavigationBar: BottomActionButton(
        text: 'Add to Cart',
        backgroundColor: AppColors.primaryColor,
        onPressed: () {
          // todo add to cart
          GoRouter.of(context).push('/cart');
        },
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              color: AppColors.iconsBg,
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 60),
                    child: SizedBox(
                      width: double.infinity,
                      height: 400,
                      child: Image.asset(
                        Assets.resourceImagesProduct,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 60,
                    left: 20,
                    right: 20,

                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomIconWithBg(
                          iconImg: Assets.resourceImagesArrowLeft,
                          backgroundColor: Colors.white,
                          onTap: () {
                            GoRouter.of(context).push('/home');
                          },
                        ),

                        CustomIconWithBg(
                          iconImg: Assets.resourceImagesBag,
                          backgroundColor: Colors.white,
                          onTap: () {
                            GoRouter.of(context).push('/cart');
                          },
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: 322,
                    left: 20,
                    right: 20,

                    child: Image.asset(Assets.resourceImagesNike),
                  ),
                ],
              ),
            ),
            // todo ______________________
            const ProductInfo(
              category: "Men's Printed Pullover Hoodie",
              name: 'Nike Club Fleece',
              price: 120,
            ),

            const SizedBox(height: 20),

            // Image Thumbnails
            ImageThumbnails(
              images: productImages,
              selectedIndex: selectedImageIndex,
              onImageSelected: (index) {
                setState(() {
                  selectedImageIndex = index;
                });
              },
            ),

            const SizedBox(height: 24),

            // Size Selection
            SizeSelector(
              sizes: sizes,
              selectedSize: selectedSize,
              onSizeSelected: (size) {
                setState(() {
                  selectedSize = size;
                });
              },
            ),

            const SizedBox(height: 24),

            // Description
            const ProductDescription(),

            const SizedBox(height: 24),

            //todo  Reviews
            const ReviewsSection(),

            const SizedBox(height: 24),

            // Total Price
            const TotalPrice(price: 125),

            const SizedBox(height: 16),
          ],
        ),
      ),

      // Add to Cart Button
    );
  }
}
