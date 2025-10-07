import 'package:flutter/material.dart';
import 'package:laza/core/common_ui/widgets/bottom_action_button.dart';
import 'package:laza/core/common_ui/widgets/custom_icon_with_bg.dart';
import 'package:laza/core/constants/assets.dart';
import 'package:laza/core/theming/app_colors.dart';

class AddReviewScreen extends StatefulWidget {
  const AddReviewScreen({super.key});

  @override
  State<AddReviewScreen> createState() => _AddReviewScreenState();
}

class _AddReviewScreenState extends State<AddReviewScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController experienceController = TextEditingController();
  double rating = 2.5;

  void submitReview() {
    final name = nameController.text.trim();
    final experience = experienceController.text.trim();

    if (name.isEmpty || experience.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please fill out all fields before submitting."),
        ),
      );
      return;
    }

    debugPrint("✅ Review submitted:");
    debugPrint("Name: $name");
    debugPrint("Experience: $experience");
    debugPrint("Rating: $rating");

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Thank you for your review! 💜")),
    );

    // You can later send this data to your backend or Firebase
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: BottomActionButton(
        backgroundColor: AppColors.primaryColor,
        text: 'Submit Review',
        onPressed: () {},
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🧭 Top bar (Back + Title)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomIconWithBg(
                    iconImg: Assets.resourceImagesArrowLeft,
                    backgroundColor: AppColors.iconsBg, onTap: () {  },
                  ),
                  const Text(
                    'Add Review',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(width: 45), // keeps center alignment visually
                ],
              ),
              const SizedBox(height: 30),

              // 👤 Name Field
              const Text(
                "Name",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
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

              // 💬 Experience Field
              const Text(
                "How was your experience ?",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: experienceController,
                maxLines: 6,
                decoration: InputDecoration(
                  hintText: "Describe your experience?",
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

              // ⭐ Star Rating
              const Text(
                "Star",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Text("0.0", style: TextStyle(color: Colors.black87)),
                  Expanded(
                    child: Slider(
                      value: rating,
                      min: 0.0,
                      max: 5.0,
                      divisions: 10,
                      activeColor: const Color(0xFF9B6CF6), // Purple tone
                      inactiveColor: const Color(0xFFF6F7FB),
                      onChanged: (value) {
                        setState(() => rating = value);
                      },
                    ),
                  ),
                  const Text("5.0", style: TextStyle(color: Colors.black87)),
                ],
              ),
              const SizedBox(height: 10),

              // 🟣 Current Rating Value
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
              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }
}
