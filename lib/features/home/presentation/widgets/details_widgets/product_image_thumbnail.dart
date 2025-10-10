import 'package:flutter/material.dart';
import 'package:laza/core/utils/theming/app_colors.dart';
import 'package:laza/core/constants/assets.dart'; // ✅ Make sure this is imported for the fallback image

class ImageThumbnails extends StatelessWidget {
  final List<String> images;
  final int selectedIndex;
  final Function(int) onImageSelected;

  const ImageThumbnails({
    super.key,
    required this.images,
    required this.selectedIndex,
    required this.onImageSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, bottom: 15),
      child: SizedBox(
        height: 100,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: images.isNotEmpty ? images.length : 1,
          itemBuilder: (context, index) {
            final isSelected = index == selectedIndex;
            final imageUrl = images.isNotEmpty
                ? images[index]
                : Assets.resourceImagesProduct;
            return GestureDetector(
              onTap: () => onImageSelected(index),
              child: Container(
                width: 100,
                margin: const EdgeInsets.only(right: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F6FA),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isSelected
                        ? AppColors.primaryColor
                        : Colors.transparent,
                    width: 2,
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: imageUrl.startsWith('http')
                      ? Image.network(
                          imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Image.asset(
                                Assets.resourceImagesProduct,
                                fit: BoxFit.cover,
                              ),
                        )
                      : Image.asset(imageUrl, fit: BoxFit.cover),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
