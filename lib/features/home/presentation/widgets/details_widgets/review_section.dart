// // widgets/reviews_section.dart
// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';

// class ReviewsSection extends StatelessWidget {
//   final String productId;

//   const ReviewsSection({super.key, required this.productId});

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 20.0),
//       child: Column(
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 'Reviews',
//                 style: TextStyle(
//                   fontSize: 20,
//                   fontWeight: FontWeight.bold,
//                   color: Theme.of(context).textTheme.bodyLarge?.color,
//                 ),
//               ),
//               GestureDetector(
//                 onTap: () {
//                   GoRouter.of(context).push('/reviews', extra: productId);
//                 },
//                 child: Text(
//                   'View All',
//                   style: TextStyle(color: Colors.grey[600], fontSize: 15),
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 16),
//           const ReviewCard(
//             name: 'Ronald Richards',
//             date: '13 Sep, 2020',
//             rating: 4.8,
//             review:
//                 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Pellentesque malesuada eget vitae amet...',
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:laza/core/di.dart';
import 'package:laza/features/home/presentation/cubit/review_cubit/review_cubit.dart';
import 'package:laza/features/home/presentation/cubit/review_cubit/review_state.dart';

/// -------------------------
/// 🟣 Single Review Card
/// -------------------------
class ReviewCard extends StatelessWidget {
  final String? id;
  final String name;
  final String date;
  final double rating;
  final String review;
  final String? userPicture; // ✅ add this
  final String? experience;

  const ReviewCard({
    super.key,
    this.id,
    required this.name,
    required this.date,
    required this.rating,
    required this.review,
    this.userPicture, // ✅ add this
    this.experience,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2A2A2A) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? Colors.grey[700]! : Colors.grey[200]!,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🧍 User Info Row
          Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: Colors.grey[300],
                backgroundImage: userPicture != null
                    ? NetworkImage(userPicture!)
                    : null,
                child: userPicture == null
                    ? const Icon(Icons.person, color: Colors.grey)
                    : null,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 🧾 Name + Rating
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          name,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).textTheme.bodyLarge?.color,
                          ),
                        ),
                        Row(
                          children: [
                            Text(
                              rating.toStringAsFixed(1),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Theme.of(
                                  context,
                                ).textTheme.bodyLarge?.color,
                              ),
                            ),
                            const SizedBox(width: 4),
                            const Icon(
                              Icons.star,
                              size: 16,
                              color: Colors.orange,
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    // ⏰ Date
                    Row(
                      children: [
                        const Icon(
                          Icons.access_time,
                          size: 14,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          date ?? "Recent",
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // 💬 Review Text
          Text(
            review,
            style: TextStyle(
              color: isDark ? Colors.grey[400] : Colors.grey[700],
              fontSize: 14,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

/// -------------------------
/// 🟣 Reviews Section (List)
/// -------------------------
class ReviewsSection extends StatelessWidget {
  final String productId;

  const ReviewsSection({super.key, required this.productId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ReviewCubit>()..getReviews(productId),
      child: BlocBuilder<ReviewCubit, ReviewState>(
        builder: (context, state) {
          if (state is ReviewLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ReviewLoaded) {
            final reviews = state.reviews;
            if (reviews.isEmpty) {
              return _buildEmptyState(context);
            }

            // ✅ Show up to 2 latest reviews
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _header(context),
                  const SizedBox(height: 16),
                  ...reviews
                      .take(2)
                      .map(
                        (r) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: ReviewCard(
                            id: r.id,
                            name: r.userName,
                            date: r.date ?? "Recent",
                            rating: r.rating,
                            review: r.comment,
                            userPicture: r.userPicture,
                          ),
                        ),
                      ),
                ],
              ),
            );
          } else if (state is ReviewError) {
            return Padding(
              padding: const EdgeInsets.all(20),
              child: Text(
                "Failed to load reviews: ${state.message}",
                style: const TextStyle(color: Colors.red),
              ),
            );
          }
          return const SizedBox();
        },
      ),
    );
  }

  /// Empty state if no reviews exist
  Widget _buildEmptyState(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _header(context),
          const SizedBox(height: 12),
          const Text(
            "No reviews yet. Be the first to add one!",
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  /// Header with "View All" button
  Widget _header(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Reviews',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).textTheme.bodyLarge?.color,
          ),
        ),
        GestureDetector(
          onTap: () {
            GoRouter.of(context).push('/reviews', extra: productId);
          },
          child: const Text(
            'View All',
            style: TextStyle(
              color: Colors.deepPurple,
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}
