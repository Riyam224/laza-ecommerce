import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:laza/core/common_ui/widgets/bottom_action_button.dart';
import 'package:laza/core/common_ui/widgets/custom_icon_with_bg.dart';
import 'package:laza/core/constants/assets.dart';
import 'package:laza/core/di/di.dart';
import 'package:laza/core/utils/theming/app_colors.dart';
import 'package:laza/features/home/domain/entities/review_entity.dart';
import 'package:laza/features/home/presentation/cubit/review_cubit/review_cubit.dart';
import 'package:laza/features/home/presentation/cubit/review_cubit/review_state.dart';

class AddReviewScreen extends StatefulWidget {
  final String productId;

  const AddReviewScreen({super.key, required this.productId});

  @override
  State<AddReviewScreen> createState() => _AddReviewScreenState();
}

class _AddReviewScreenState extends State<AddReviewScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController experienceController = TextEditingController();
  double rating = 2.5;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ReviewCubit>(),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: BlocConsumer<ReviewCubit, ReviewState>(
            listener: (context, state) {
              if (state is ReviewPosted) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(state.message)));
                GoRouter.of(context).pop();
              } else if (state is ReviewError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            builder: (context, state) {
              final isLoading = state is ReviewPosting;

              return Column(
                children: [
                  Expanded(
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
                                onTap: () => GoRouter.of(context).pop(),
                              ),
                              const Text(
                                'Add Review',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(width: 45),
                            ],
                          ),
                          const SizedBox(height: 30),

                          // 👤 Name field
                          const Text(
                            "Name",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextField(
                            controller: nameController,
                            decoration: InputDecoration(
                              hintText: "Type your name",
                              filled: true,
                              fillColor: const Color(0xFFF6F7FB),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14),
                                borderSide: BorderSide.none,
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 16,
                              ),
                            ),
                          ),
                          const SizedBox(height: 25),

                          // 💬 Experience field
                          const Text(
                            "How was your experience?",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextField(
                            controller: experienceController,
                            maxLines: 6,
                            decoration: InputDecoration(
                              hintText: "Describe your experience...",
                              filled: true,
                              fillColor: const Color(0xFFF6F7FB),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14),
                                borderSide: BorderSide.none,
                              ),
                              contentPadding: const EdgeInsets.all(16),
                            ),
                          ),
                          const SizedBox(height: 25),

                          // ⭐ Rating
                          const Text(
                            "Star",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Text("0.0"),
                              Expanded(
                                child: Slider(
                                  value: rating,
                                  min: 0.0,
                                  max: 5.0,
                                  divisions: 10,
                                  activeColor: AppColors.primaryColor,
                                  inactiveColor: const Color(0xFFF6F7FB),
                                  onChanged: (value) {
                                    setState(() => rating = value);
                                  },
                                ),
                              ),
                              const Text("5.0"),
                            ],
                          ),
                          Center(
                            child: Text(
                              "Your Rating: ${rating.toStringAsFixed(1)} ⭐",
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.black54,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // 🟣 Submit Button
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: BottomActionButton(
                      backgroundColor: AppColors.primaryColor,
                      text: isLoading ? 'Submitting...' : 'Submit Review',
                      onPressed: isLoading
                          ? null
                          : () {
                              FocusScope.of(context).unfocus(); // hide keyboard
                              final name = nameController.text.trim();
                              final experience = experienceController.text
                                  .trim();

                              if (name.isEmpty || experience.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Please fill all fields'),
                                  ),
                                );
                                return;
                              }

                              final review = ReviewEntity(
                                userName: name,
                                comment: experience,
                                rating: rating,
                              );

                              context.read<ReviewCubit>().postReview(
                                widget.productId,
                                review,
                              );
                            },
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
