import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:laza/core/common_ui/widgets/custom_icon_with_bg.dart';
import 'package:laza/core/constants/assets.dart';
import 'package:laza/core/theming/app_colors.dart';

import 'package:laza/features/reviews/presentation/widgets/reviews_list.dart';

class ReviewsScreen extends StatelessWidget {
  const ReviewsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 30),
          child: Column(
            children: [
              SizedBox(height: 40),
              Row(
                children: [
                  CustomIconWithBg(
                    iconImg: Assets.resourceImagesArrowLeft,
                    backgroundColor: AppColors.iconsBg,
                    onTap: () {
                      GoRouter.of(context).go('/productDetails');
                    },
                  ),
                  SizedBox(width: 85),
                  Text(
                    textAlign: TextAlign.center,
                    'Reviews',
                    style: TextStyle(
                      color: const Color(0xFF1D1E20),
                      fontSize: 17,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w600,
                      height: 1.10,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 25),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // 🧾 Reviews info (left side)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '245 Reviews',
                        style: TextStyle(
                          color: const Color(0xFF1D1E20),
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
                      // todo add review
                      GoRouter.of(context).push('/addReview');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFED7545), // Orange color
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
              ),
              SizedBox(height: 32),
              ReviewsList(),
            ],
          ),
        ),
      ),
    );
  }
}
