
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
          Text(
            'Description',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).textTheme.bodyLarge?.color,
            ),
          ),
          const SizedBox(height: 12),
          Builder(
            builder: (context) {
              return RichText(
                text: TextSpan(
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 15,
                    height: 1.6,
                  ),
                  children: [
                    const TextSpan(
                      text:
                          'The Nike Throwback Pullover Hoodie is made from premium French terry fabric that blends a performance feel with ',
                    ),
                    TextSpan(
                      text: 'Read More..',
                      style: TextStyle(
                        color: Theme.of(context).textTheme.bodyLarge?.color,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
