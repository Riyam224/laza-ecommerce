import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:laza/core/di/di.dart';
import 'package:laza/core/utils/theming/app_colors.dart';
import 'package:laza/features/home/domain/entities/product_entity.dart';
import 'package:laza/features/home/presentation/cubit/category_products/category_products_cubit.dart';
import 'package:laza/features/home/presentation/widgets/home_widgets/home_custom_header.dart';

class CategoryProductsPage extends StatelessWidget {
  final String categoryId;
  final String categoryName;
  final String categoryLogo;

  const CategoryProductsPage({
    super.key,
    required this.categoryId,
    required this.categoryName,
    required this.categoryLogo,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          sl<CategoryProductsCubit>()..loadCategoryProducts(categoryId),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🔙 Header Row
              const CustomHeader(bgColor: AppColors.iconsBg),

              // 🧾 Title and Info
              BlocBuilder<CategoryProductsCubit, CategoryProductsState>(
                builder: (context, state) {
                  List<ProductEntity> products = [];

                  if (state is CategoryProductsLoaded) {
                    products = state.products;
                  }

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (state is CategoryProductsLoading)
                                      const Text(
                                        'Loading...',
                                        style: TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      )
                                    else
                                      Text(
                                        '${products.length} Items',
                                        style: const TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    const SizedBox(height: 4),
                                    const Text(
                                      'Available in stock',
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF4F4F4),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 8,
                                  ),
                                  child: const Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(Icons.sort, size: 18),
                                      SizedBox(width: 6),
                                      Text('Sort'),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                    ],
                  );
                },
              ),

              // 🛍️ Grid of Products
              Expanded(
                child:
                    BlocBuilder<CategoryProductsCubit, CategoryProductsState>(
                      builder: (context, state) {
                        if (state is CategoryProductsLoading) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        if (state is CategoryProductsError) {
                          return Center(
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
                                    context
                                        .read<CategoryProductsCubit>()
                                        .loadCategoryProducts(categoryId);
                                  },
                                  child: const Text('Retry'),
                                ),
                              ],
                            ),
                          );
                        }

                        if (state is CategoryProductsLoaded) {
                          final products = state.products;

                          if (products.isEmpty) {
                            return const Center(
                              child: Text('No products in this category'),
                            );
                          }

                          return GridView.builder(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            itemCount: products.length,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  mainAxisExtent: 270,
                                  mainAxisSpacing: 16,
                                  crossAxisSpacing: 16,
                                ),
                            itemBuilder: (context, index) {
                              final product = products[index];
                              return _ProductCard(product: product);
                            },
                          );
                        }

                        return const SizedBox.shrink();
                      },
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// 🧱 Simple Product Card Widget
class _ProductCard extends StatelessWidget {
  final ProductEntity product;
  const _ProductCard({required this.product});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(
                  product.coverPictureUrl,
                  height: 170,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              const Positioned(
                top: 8,
                right: 8,
                child: CircleAvatar(
                  radius: 16,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.favorite_border, size: 18),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Name
          GestureDetector(
            onTap: () {
              (context).push('/productDetails', extra: product.id);
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: Text(
                product.name,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),

          const SizedBox(height: 4),

          // Price
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: Text(
              '\$${product.price.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
