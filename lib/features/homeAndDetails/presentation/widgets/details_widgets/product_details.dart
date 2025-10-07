
// widgets/product_description.dart
import 'package:flutter/material.dart';

class ProductDescription extends StatelessWidget {
  const ProductDescription({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Description',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          RichText(
            text: TextSpan(
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 15,
                height: 1.6,
              ),
              children: const [
                TextSpan(
                  text:
                      'The Nike Throwback Pullover Hoodie is made from premium French terry fabric that blends a performance feel with ',
                ),
                TextSpan(
                  text: 'Read More..',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
