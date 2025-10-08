import 'package:flutter/material.dart';
import 'package:laza/features/home/presentation/widgets/details_widgets/review_section.dart';

class ReviewsList extends StatelessWidget {
  const ReviewsList({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> reviews = [
      {
        'name': 'Ronald Richards',
        'date': '13 Sep, 2020',
        'rating': 4.8,
        'review':
            'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Pellentesque malesuada eget vitae amet...',
      },
      {
        'name': 'Esther Howard',
        'date': '10 Aug, 2020',
        'rating': 4.5,
        'review':
            'Great material and fit! Totally recommend it for daily wear.',
      },
      {
        'name': 'Jenny Wilson',
        'date': '02 July, 2020',
        'rating': 4.0,
        'review': 'Nice hoodie, but delivery was a bit late.',
      },
      {
        'name': 'Jenny Wilson',
        'date': '02 July, 2020',
        'rating': 4.0,
        'review': 'Nice hoodie, but delivery was a bit late.',
      },
      {
        'name': 'Jenny Wilson',
        'date': '02 July, 2020',
        'rating': 4.0,
        'review': 'Nice hoodie, but delivery was a bit late.',
      },
      {
        'name': 'Jenny Wilson',
        'date': '02 July, 2020',
        'rating': 4.0,
        'review': 'Nice hoodie, but delivery was a bit late.',
      },
    ];

    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 20),
      physics: const BouncingScrollPhysics(),
      shrinkWrap: true,
      itemCount: reviews.length,
      itemBuilder: (context, index) {
        final review = reviews[index];
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: ReviewCard(
            name: review['name'],
            date: review['date'],
            rating: review['rating'],
            review: review['review'],
          ),
        );
      },
    );
  }
}
