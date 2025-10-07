// widgets/total_price.dart
import 'package:flutter/material.dart';

class TotalPrice extends StatelessWidget {
  final int price;

  const TotalPrice({super.key, required this.price});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Total Price',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                'with VAT,SD',
                style: TextStyle(color: Colors.grey[400], fontSize: 13),
              ),
            ],
          ),
          Text(
            '\$$price',
            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
