// screens/product_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:laza/core/common_ui/widgets/bottom_action_button.dart';
import 'package:laza/core/common_ui/widgets/custom_icon_with_bg.dart';
import 'package:laza/core/constants/assets.dart';
import 'package:laza/core/di.dart';
import 'package:laza/core/theming/app_colors.dart';
import 'package:laza/features/home/presentation/cubit/product_cubit/product_cubit.dart';
import 'package:laza/features/home/presentation/cubit/product_cubit/product_state.dart';
import 'package:laza/features/home/presentation/widgets/details_widgets/product_details.dart';
import 'package:laza/features/home/presentation/widgets/details_widgets/product_details_size_selector.dart';
import 'package:laza/features/home/presentation/widgets/details_widgets/product_details_total_price.dart';
import 'package:laza/features/home/presentation/widgets/details_widgets/product_image_thumbnail.dart';
import 'package:laza/features/home/presentation/widgets/details_widgets/product_info.dart';
import 'package:laza/features/home/presentation/widgets/details_widgets/review_section.dart';

class ProductDetailScreen extends StatefulWidget {
  final String? productId;

  const ProductDetailScreen({super.key, this.productId});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  String selectedSize = 'M';
  int selectedImageIndex = 0;
  final List<String> sizes = ['S', 'M', 'L', 'XL', '2XL'];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          sl<ProductCubit>()..getProductById(widget.productId ?? '1'),
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: BlocBuilder<ProductCubit, ProductState>(
          builder: (context, state) {
            if (state is ProductDetailLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is ProductError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        state.message,
                        style: const TextStyle(color: Colors.red),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          context.read<ProductCubit>().getProductById(
                            widget.productId ?? '1',
                          );
                        },
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                ),
              );
            }

            if (state is ProductDetailLoaded) {
              final product = state.product;

              // Create list of images using the product's cover image
              // final List<String> productImages = [
              //   product.coverPictureUrl,
              //   product.coverPictureUrl,
              //   product.coverPictureUrl,
              //   product.coverPictureUrl,
              // ];
              // ✅ Use the same cover image 4 times for thumbnails
              final List<String> productImages = List.filled(
                4,
                product.coverPictureUrl,
              );

              // todo. _____________________
              return Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
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
                                    // todo image _____
                                    child: Image.network(
                                      product.coverPictureUrl,
                                      fit: BoxFit.contain,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                            return Image.asset(
                                              Assets.resourceImagesProduct,
                                              fit: BoxFit.contain,
                                            );
                                          },
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: 60,
                                  left: 20,
                                  right: 20,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      CustomIconWithBg(
                                        iconImg: Assets.resourceImagesArrowLeft,
                                        backgroundColor: Colors.white,
                                        onTap: () {
                                          GoRouter.of(context).pop();
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
                                // todo fix it later
                                // Positioned(
                                //   top: 322,
                                //   left: 20,
                                //   right: 20,
                                //   child: Image.asset(Assets.resourceImagesNike),
                                // ),
                              ],
                            ),
                          ),
                          ProductInfo(
                            category: "Product",
                            name: product.name,
                            price: product.price,
                          ),
                          const SizedBox(height: 20),
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
                          const ProductDescription(),
                          const SizedBox(height: 24),
                          ReviewsSection(productId: product.id),
                          const SizedBox(height: 24),
                          TotalPrice(price: product.price),
                          const SizedBox(height: 16),
                        ],
                      ),
                    ),
                  ),
                  BottomActionButton(
                    text: 'Add to Cart',
                    backgroundColor: AppColors.primaryColor,
                    onPressed: () {
                      // todo add to cart
                      GoRouter.of(context).push('/cart');
                    },
                  ),
                ],
              );
            }

            return const Center(child: Text('No product data'));
          },
        ),
      ),
    );
  }
}
