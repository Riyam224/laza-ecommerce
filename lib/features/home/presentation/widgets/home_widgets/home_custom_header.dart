// widgets/custom_header.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:laza/core/common_ui/widgets/custom_icon_with_bg.dart';
import 'package:laza/core/constants/assets.dart';

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
          CustomIconWithBg(
            iconImg: Assets.resourceImagesMenu,
            backgroundColor: bgColor,
            onTap: () {
              Scaffold.of(context).openDrawer();
            },
          ),
          CustomIconWithBg(
            iconImg: Assets.resourceImagesBag,
            backgroundColor: bgColor,
            onTap: () {
              GoRouter.of(context).push('/cart');
            },
          ),
        ],
      ),
    );
  }
}
