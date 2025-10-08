import 'package:flutter/material.dart';

class BrandSection extends StatelessWidget {
  const BrandSection({super.key});
  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> brands = [
      {'name': 'Adidas', 'image': 'assets/images/Adidas.png'},
      {'name': 'Nike', 'image': 'assets/images/nike.png'},
      {'name': 'Fila', 'image': 'assets/images/fila.png'},
      {'name': 'Puma', 'image': 'assets/images/puma.png'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),

        // 🔠 Section Header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Choose Brand',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              TextButton(
                onPressed: () {},
                child: const Text(
                  'View All',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 12),

        // 🏷️ Brand List
        SizedBox(
          height: 70,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: brands.length,
            itemBuilder: (context, index) {
              final brand = brands[index];
              return BrandCard(
                brandName: brand['name'],
                brandImage: brand['image'],
              );
            },
          ),
        ),
      ],
    );
  }
}

class BrandCard extends StatelessWidget {
  final String brandImage;
  final String brandName;

  const BrandCard({
    super.key,
    required this.brandImage,
    required this.brandName,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F6FA),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          // 🖼️ Brand Image Box
          Container(
            width: 40,
            height: 40,
            decoration: ShapeDecoration(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(6),
              child: Image.asset(brandImage, fit: BoxFit.contain),
            ),
          ),

          const SizedBox(width: 12),

          // 🏷️ Brand Name
          Text(
            brandName,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
