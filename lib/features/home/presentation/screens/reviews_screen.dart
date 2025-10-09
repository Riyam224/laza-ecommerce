import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:laza/core/common_ui/widgets/custom_icon_with_bg.dart';
import 'package:laza/core/constants/assets.dart';
import 'package:laza/core/di/di.dart';
import 'package:laza/core/utils/theming/app_colors.dart';
import 'package:laza/features/home/presentation/cubit/review_cubit/review_cubit.dart';
import 'package:laza/features/home/presentation/cubit/review_cubit/review_state.dart';
import 'package:laza/features/home/presentation/widgets/details_widgets/review_section.dart';

class ReviewsScreen extends StatelessWidget {
  final String? productId;

  const ReviewsScreen({super.key, this.productId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<ReviewCubit>()..getReviews(productId ?? '1'),
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 30),
            child: Column(
              children: [
                const SizedBox(height: 40),
                Row(
                  children: [
                    CustomIconWithBg(
                      iconImg: Assets.resourceImagesArrowLeft,
                      backgroundColor: AppColors.iconsBg,
                      onTap: () {
                        GoRouter.of(context).pop();
                      },
                    ),
                    const SizedBox(width: 85),
                    const Text(
                      textAlign: TextAlign.center,
                      'Reviews',
                      style: TextStyle(
                        color: Color(0xFF1D1E20),
                        fontSize: 17,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w600,
                        height: 1.10,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 25),
                BlocBuilder<ReviewCubit, ReviewState>(
                  builder: (context, state) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // 🧾 Reviews info (left side)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              state is ReviewLoaded
                                  ? '${state.reviews.length} Reviews'
                                  : '0 Reviews',
                              style: const TextStyle(
                                color: Color(0xFF1D1E20),
                                fontSize: 15,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w500,
                                height: 1.10,
                              ),
                            ),
                            const SizedBox(height: 6),

                            // ⭐ Rating and stars
                            Row(
                              children: [
                                const Text(
                                  '4.8',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Row(
                                  children: List.generate(
                                    5,
                                    (index) => Icon(
                                      index < 4
                                          ? Icons.star_rounded
                                          : Icons.star_border_rounded,
                                      color: Colors.orange,
                                      size: 20,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),

                        // 🧡 Add Review button
                        ElevatedButton.icon(
                          onPressed: () {
                            GoRouter.of(context).push(
                              '/addReview',
                              extra: productId, // if you pass a product ID
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(
                              0xFFED7545,
                            ), // Orange color
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 12,
                            ),
                          ),
                          icon: const Icon(
                            Icons.edit_outlined,
                            color: Colors.white,
                            size: 18,
                          ),
                          label: const Text(
                            'Add Review',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 32),
                BlocBuilder<ReviewCubit, ReviewState>(
                  builder: (context, state) {
                    if (state is ReviewLoading) {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.all(20.0),
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }

                    if (state is ReviewError) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            children: [
                              Text(
                                state.message,
                                style: const TextStyle(color: Colors.red),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 16),
                              ElevatedButton(
                                onPressed: () {
                                  context.read<ReviewCubit>().getReviews(
                                    productId ?? '1',
                                  );
                                },
                                child: const Text('Retry'),
                              ),
                            ],
                          ),
                        ),
                      );
                    }

                    if (state is ReviewLoaded) {
                      if (state.reviews.isEmpty) {
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.all(20.0),
                            child: Text('No reviews yet'),
                          ),
                        );
                      }

                      return ListView.builder(
                        padding: const EdgeInsets.only(bottom: 20),
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: state.reviews.length,
                        itemBuilder: (context, index) {
                          final review = state.reviews[index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: ReviewCard(
                              id: review.id,
                              name: review.userName,
                              date: review.date ?? 'Recent',
                              rating: review.rating.toDouble(),
                              review: review.comment,
                              userPicture: review.userPicture,
                            ),
                          );
                        },
                      );
                    }

                    return const SizedBox.shrink();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
