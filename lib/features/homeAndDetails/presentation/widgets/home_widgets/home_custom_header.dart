// widgets/custom_header.dart
import 'package:flutter/material.dart';
import 'package:laza/core/constants/assets.dart';
import 'package:laza/core/theming/app_colors.dart';

class CustomHeader extends StatelessWidget {
  const CustomHeader({super.key, required this.bgColor});
  final Color bgColor;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(25),
            ),
            child: GestureDetector(
              onTap: () {
                Scaffold.of(context).openDrawer();
              },
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Image.asset(
                  Assets.resourceImagesMenu,
                  width: 25,
                  height: 25,
                ),
              ),
            ),
          ),
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: AppColors.iconsBg,
              borderRadius: BorderRadius.circular(25),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Image.asset(
                Assets.resourceImagesBag,
                width: 25,
                height: 25,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
