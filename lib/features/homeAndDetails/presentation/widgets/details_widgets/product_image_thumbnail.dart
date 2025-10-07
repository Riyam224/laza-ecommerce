
// widgets/image_thumbnails.dart
import 'package:flutter/material.dart';

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
          itemCount: images.length,
          itemBuilder: (context, index) {
            final isSelected = index == selectedIndex;
            return GestureDetector(
              onTap: () => onImageSelected(index),
              child: Container(
                width: 100,
                margin: const EdgeInsets.only(right: 12),
                decoration: BoxDecoration(
                  color: isSelected
                      ? const Color(0xFFD4F5E9)
                      : const Color(0xFFF5F6FA),
                  borderRadius: BorderRadius.circular(16),
                  border: isSelected
                      ? Border.all(color: const Color(0xFF7FD8BE), width: 2)
                      : null,
                ),
                child: Center(
                  // Replace with Image.asset(images[index])
                  child: Icon(
                    Icons.checkroom,
                    size: 50,
                    color: Colors.grey[600],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
