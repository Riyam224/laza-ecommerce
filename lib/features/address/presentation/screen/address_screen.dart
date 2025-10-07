import 'package:flutter/material.dart';
import 'package:laza/core/common_ui/widgets/bottom_action_button.dart';
import 'package:laza/core/common_ui/widgets/custom_icon_with_bg.dart';
import 'package:laza/core/constants/assets.dart';
import 'package:laza/core/theming/app_colors.dart';

class AddressScreen extends StatefulWidget {
  const AddressScreen({super.key});

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  bool isPrimary = true;

  final _nameController = TextEditingController(text: 'Mrh Raju');
  final _countryController = TextEditingController(text: 'Bangladesh');
  final _cityController = TextEditingController(text: 'Sylhet');
  final _phoneController = TextEditingController(text: '+880 1453-987533');
  final _addressController = TextEditingController(
    text: 'Chhatak, Sunamgonj 12/8AB',
  );

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
              // 🔙 Back Button + Title
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomIconWithBg(
                    iconImg: Assets.resourceImagesArrowLeft,
                    backgroundColor: AppColors.iconsBg,
                    onTap: () => Navigator.pop(context),
                  ),
                  const Text(
                    'Address',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(width: 45),
                ],
              ),
              const SizedBox(height: 24),

              // 🧍 Name
              _buildLabel('Name'),
              _buildTextField(controller: _nameController, hint: 'Name'),
              const SizedBox(height: 16),

              // 🌍 Country & City
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLabel('Country'),
                        _buildTextField(
                          controller: _countryController,
                          hint: 'Country',
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLabel('City'),
                        _buildTextField(
                          controller: _cityController,
                          hint: 'City',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // 📞 Phone Number
              _buildLabel('Phone Number'),
              _buildTextField(
                controller: _phoneController,
                hint: 'Phone Number',
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 16),

              // 🏠 Address
              _buildLabel('Address'),
              _buildTextField(controller: _addressController, hint: 'Address'),
              const SizedBox(height: 24),

              // 🔘 Save as primary toggle
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Save as primary address',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  Switch(
                    value: isPrimary,
                    onChanged: (value) => setState(() => isPrimary = value),
                    activeColor: Colors.white,
                    activeTrackColor: Colors.green,
                    inactiveTrackColor: Colors.grey.shade300,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),

      // 🟣 Save Address Button
      bottomNavigationBar: BottomActionButton(
        text: 'Save Address',
        onPressed: () {},
        backgroundColor: AppColors.primaryColor,
      ),
    );
  }

  // 🧩 Helper Widgets

  Widget _buildLabel(String text) => Padding(
    padding: const EdgeInsets.only(bottom: 8.0),
    child: Text(
      text,
      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
    ),
  );

  Widget _buildTextField({
    required TextEditingController controller,
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
