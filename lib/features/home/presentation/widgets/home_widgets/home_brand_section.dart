import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:laza/core/di.dart';
import 'package:laza/core/routing/routes.dart';
import 'package:laza/features/home/presentation/cubit/category_cubit/category_cubit.dart';
import 'package:laza/features/home/presentation/cubit/category_cubit/category_state.dart';

class BrandSection extends StatelessWidget {
  const BrandSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<CategoryCubit>()..getCategories(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 24),

          // 🔠 Section Header
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              'Choose Brand',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),

          const SizedBox(height: 12),

          // 🏷️ Category List
          BlocBuilder<CategoryCubit, CategoryState>(
            builder: (context, state) {
              if (state is CategoryLoading) {
                return const SizedBox(
                  height: 70,
                  child: Center(child: CircularProgressIndicator()),
                );
              }

              if (state is CategoryError) {
                return SizedBox(
                  height: 70,
                  child: Center(
                    child: Text(
                      state.message,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                );
              }

              if (state is CategoryLoaded) {
                final categories = state.categories;

                if (categories.isEmpty) {
                  return const Center(child: Text('No categories found.'));
                }

                return SizedBox(
                  height: 70,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      final category = categories[index];
                      return BrandCard(
                        categoryId: category.id,
                        brandName: category.name,
                        brandImage: category.coverPictureUrl ?? '',
                      );
                    },
                  ),
                );
              }

              return const SizedBox.shrink();
            },
          ),
        ],
      ),
    );
  }
}

class BrandCard extends StatelessWidget {
  final String categoryId;
  final String brandImage;
  final String brandName;

  const BrandCard({
    super.key,
    required this.categoryId,
    required this.brandImage,
    required this.brandName,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.pushNamed(
          AppRoutes.categoryProducts,
          extra: {
            'categoryId': categoryId,
            'categoryName': brandName,
            'categoryLogo': brandImage,
          },
        );
      },
      child: Container(
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xFFF5F6FA),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
          // 🖼️ Brand Image Box
          Container(
            width: 40,
            height: 40,
            decoration: ShapeDecoration(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(6),
              child: brandImage.isEmpty
                  ? const Icon(Icons.category, size: 24, color: Colors.grey)
                  : Image.network(
                      brandImage,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(
                          Icons.category,
                          size: 24,
                          color: Colors.grey,
                        );
                      },
                    ),
            ),
          ),

          const SizedBox(width: 12),

          // 🏷️ Brand Name
          Text(
            brandName,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ],
      ),
      ),
    );
  }
}
