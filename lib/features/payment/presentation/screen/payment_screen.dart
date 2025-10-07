import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:laza/core/common_ui/widgets/bottom_action_button.dart';
import 'package:laza/core/common_ui/widgets/custom_icon_with_bg.dart';
import 'package:laza/core/constants/assets.dart';
import 'package:laza/core/theming/app_colors.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  bool saveCard = true;
  int currentCard = 0;

  final List<Map<String, dynamic>> cards = [
    {
      'owner': 'Mrh Raju',
      'type': 'Visa Classic',
      'number': '5254 **** **** 7690',
      'balance': '\$3,763.87',
      'gradient': [Color(0xFFFFC857), Color(0xFFFF595E)],
    },
    {
      'owner': 'John Doe',
      'type': 'Visa Platinum',
      'number': '4892 **** **** 5214',
      'balance': '\$1,248.52',
      'gradient': [Color(0xFFA6C48A), Color(0xFF52796F)],
    },
    {
      'owner': 'Emma Watson',
      'type': 'Visa Gold',
      'number': '4213 **** **** 7625',
      'balance': '\$6,921.40',
      'gradient': [Color(0xFF9B6CF6), Color(0xFF7B2FF7)],
    },
  ];

  final _ownerController = TextEditingController(text: 'Mrh Raju');
  final _cardNumberController = TextEditingController(
    text: '5254 7634 8734 7690',
  );
  final _expController = TextEditingController(text: '24/24');
  final _cvvController = TextEditingController(text: '7763');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🔙 Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomIconWithBg(
                    iconImg: Assets.resourceImagesArrowLeft,
                    backgroundColor: AppColors.iconsBg,
                    onTap: () => Navigator.pop(context),
                  ),
                  const Text(
                    'Payment',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(width: 45),
                ],
              ),
              const SizedBox(height: 24),
              CarouselSlider.builder(
                itemCount: cards.length,
                itemBuilder: (context, index, realIdx) {
                  final card = cards[index];
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    width: MediaQuery.of(context).size.width * 0.82,
                    height: 220,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18),
                      gradient: LinearGradient(
                        colors: List<Color>.from(card['gradient']),
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        if (currentCard == index)
                          BoxShadow(
                            color: card['gradient'][1].withOpacity(0.4),
                            blurRadius: 25,
                            offset: const Offset(0, 8),
                          ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 20,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // 👤 Owner
                          Text(
                            card['owner'],
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 14),

                          // 💳 Type
                          Text(
                            card['type'],
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          const SizedBox(height: 24),

                          // 🔢 Number
                          Text(
                            card['number'],
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              letterSpacing: 3,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const Spacer(),

                          // 💰 Balance + VISA logo
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                card['balance'],
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 21,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 6),
                                child: Image.asset(
                                  Assets.resourceImagesVisa,
                                  width: 55,
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
                options: CarouselOptions(
                  height: 255,
                  enlargeCenterPage: true,
                  viewportFraction: 0.96,
                  enableInfiniteScroll: false,
                  enlargeStrategy: CenterPageEnlargeStrategy.height,
                  onPageChanged: (index, reason) {
                    setState(() {
                      currentCard = index;
                      _ownerController.text = cards[index]['owner'];
                    });
                  },
                ),
              ),
              const SizedBox(height: 16),

              // ➕ Add new card button
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  vertical: 14,
                  horizontal: 16,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFF9F5FF),
                  border: Border.all(color: AppColors.primaryColor, width: 1.5),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.add_circle_outline,
                      color: AppColors.primaryColor,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Add new card',
                      style: TextStyle(
                        color: AppColors.primaryColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // 🧾 Card form fields
              _buildLabel('Card Owner'),
              _buildTextField(_ownerController, hint: 'Card Owner'),
              const SizedBox(height: 16),

              _buildLabel('Card Number'),
              _buildTextField(
                _cardNumberController,
                hint: 'Card Number',
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLabel('EXP'),
                        _buildTextField(_expController, hint: 'MM/YY'),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLabel('CVV'),
                        _buildTextField(_cvvController, hint: '****'),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // 💾 Save toggle
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Save card info',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  Switch(
                    value: saveCard,
                    onChanged: (value) => setState(() => saveCard = value),
                    activeColor: Colors.white,
                    activeTrackColor: Colors.green,
                    inactiveTrackColor: Colors.grey.shade300,
                  ),
                ],
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),

      // 🟣 Save Card Button
      bottomNavigationBar: BottomActionButton(
        text: 'Save Card',
        onPressed: () {},
        backgroundColor: AppColors.primaryColor,
      ),
    );
  }

  // 🧩 Reusable widgets
  Widget _buildLabel(String text) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Text(
      text,
      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
    ),
  );

  Widget _buildTextField(
    TextEditingController controller, {
    required String hint,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      style: const TextStyle(fontSize: 16, color: Colors.black),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.grey),
        filled: true,
        fillColor: const Color(0xFFF6F7FB),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
