// // ignore_for_file: deprecated_member_use

// import 'package:flutter/material.dart';
// import 'package:laza/core/common_ui/widgets/custom_icon_with_bg.dart';
// import 'package:laza/core/theming/app_colors.dart';
// import 'package:laza/core/constants/assets.dart';

// class CustomDrawer extends StatelessWidget {
//   const CustomDrawer({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Drawer(
//       backgroundColor: Colors.white,
//       child: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 45),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               CustomIconWithBg(
//                 iconImg: Assets.resourceImagesMenuDrawer,
//                 backgroundColor: AppColors.iconsBg,
//                 onTap: () async {
//                   Navigator.of(context).pop(); // Close drawer
//                   await Future.delayed(const Duration(milliseconds: 200));
//                   // Optionally do something else (navigate, show dialog, etc.)
//                 },
//               ),
//               SizedBox(height: 30),
//               // 🔹 Profile section
//               Row(
//                 children: [
//                   // Profile Picture
//                   CircleAvatar(
//                     radius: 28,
//                     backgroundImage: AssetImage(Assets.resourceImagesProfile),
//                   ),
//                   const SizedBox(width: 12),
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: const [
//                         Text(
//                           'Mrh Raju',
//                           style: TextStyle(
//                             fontSize: 17,
//                             fontWeight: FontWeight.w600,
//                           ),
//                         ),
//                         SizedBox(height: 4),
//                         Row(
//                           children: [
//                             Text(
//                               'Verified Profile',
//                               style: TextStyle(
//                                 color: Colors.grey,
//                                 fontSize: 13,
//                               ),
//                             ),
//                             SizedBox(width: 4),
//                             Icon(Icons.verified, color: Colors.green, size: 16),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                   // Orders Button
//                   Container(
//                     padding: const EdgeInsets.symmetric(
//                       horizontal: 10,
//                       vertical: 6,
//                     ),
//                     decoration: BoxDecoration(
//                       color: const Color(0xFFF6F7FB),
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                     child: const Text(
//                       '3 Orders',
//                       style: TextStyle(
//                         fontSize: 13,
//                         fontWeight: FontWeight.w500,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 30),

//               // 🌙 Dark mode toggle
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Row(
//                     children: const [
//                       Icon(Icons.light_mode_outlined),
//                       SizedBox(width: 12),
//                       Text('Dark Mode', style: TextStyle(fontSize: 16)),
//                     ],
//                   ),
//                   Switch(
//                     value: false,
//                     onChanged: (_) {},
//                     activeColor: AppColors.primaryColor,
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 16),

//               // 🧭 Menu Items
//               _drawerItem(context, Icons.info_outline, 'Account Information'),
//               _drawerItem(context, Icons.lock_outline, 'Password'),
//               _drawerItem(context, Icons.shopping_bag_outlined, 'Order'),
//               _drawerItem(context, Icons.credit_card_outlined, 'My Cards'),
//               _drawerItem(context, Icons.favorite_border, 'Wishlist'),
//               _drawerItem(context, Icons.settings_outlined, 'Settings'),

//               const Spacer(),

//               // 🚪 Logout
//               ListTile(
//                 leading: const Icon(Icons.logout, color: Colors.red),
//                 title: const Text(
//                   'Logout',
//                   style: TextStyle(
//                     color: Colors.red,
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ),
//                 onTap: () {
//                   // Navigator.pop(context);
//                 },
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   // Helper for menu items
//   Widget _drawerItem(BuildContext context, IconData icon, String title) {
//     return ListTile(
//       leading: Icon(icon, color: Colors.black),
//       title: Text(title, style: const TextStyle(fontSize: 16)),
//       onTap: () {
//         // Navigator.pop(context);
//       },
//       dense: true,
//       visualDensity: const VisualDensity(vertical: -2),
//     );
//   }
// }

// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:laza/core/common_ui/widgets/custom_icon_with_bg.dart';
import 'package:laza/core/theming/app_colors.dart';
import 'package:laza/core/constants/assets.dart';
import 'package:laza/features/homeAndDetails/presentation/screens/home_screen.dart';
import 'package:laza/features/payment/presentation/screen/add_new_card_screen.dart';

// 🧭 Import your screens here

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 45),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomIconWithBg(
                iconImg: Assets.resourceImagesMenuDrawer,
                backgroundColor: AppColors.iconsBg,
                onTap: () async {
                  Navigator.of(context).pop(); // ✅ close drawer
                  await Future.delayed(const Duration(milliseconds: 200));
                },
              ),
              const SizedBox(height: 30),

              // 🔹 Profile section
              Row(
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundImage: AssetImage(Assets.resourceImagesProfile),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Mrh Raju',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 4),
                        Row(
                          children: [
                            Text(
                              'Verified Profile',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 13,
                              ),
                            ),
                            SizedBox(width: 4),
                            Icon(Icons.verified, color: Colors.green, size: 16),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF6F7FB),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      '3 Orders',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),

              // 🌙 Dark mode toggle
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: const [
                      Icon(Icons.light_mode_outlined),
                      SizedBox(width: 12),
                      Text('Dark Mode', style: TextStyle(fontSize: 16)),
                    ],
                  ),
                  Switch(
                    value: false,
                    onChanged: (_) {},
                    activeColor: AppColors.primaryColor,
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // 🧭 Menu Items with navigation
              _drawerItem(
                context,
                Icons.info_outline,
                'Account Information',
                const HomeScreen(),
              ),
              _drawerItem(
                context,
                Icons.lock_outline,
                'Password',
                const HomeScreen(),
              ),
              _drawerItem(
                context,
                Icons.shopping_bag_outlined,
                'Order',
                const HomeScreen(),
              ),
              _drawerItem(
                context,
                Icons.credit_card_outlined,
                'My Cards',
                const AddNewCardScreen(),
              ),
              _drawerItem(
                context,
                Icons.favorite_border,
                'Wishlist',
                const HomeScreen(),
              ),
              _drawerItem(
                context,
                Icons.settings_outlined,
                'Settings',
                const HomeScreen(),
              ),

              const Spacer(),

              // 🚪 Logout
              ListTile(
                leading: const Icon(Icons.logout, color: Colors.red),
                title: const Text(
                  'Logout',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                onTap: () {
                  Navigator.of(context).pop(); // Close drawer first
                  Future.delayed(const Duration(milliseconds: 200), () {
                    // Add your logout logic or redirect to login
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 🔸 Drawer Item Helper with navigation
  Widget _drawerItem(
    BuildContext context,
    IconData icon,
    String title,
    Widget page,
  ) {
    return ListTile(
      leading: Icon(icon, color: Colors.black),
      title: Text(title, style: const TextStyle(fontSize: 16)),
      onTap: () async {
        Navigator.of(context).pop(); // ✅ Close drawer first
        await Future.delayed(const Duration(milliseconds: 200));
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => page), // ✅ Navigate to screen
        );
      },
      dense: true,
      visualDensity: const VisualDensity(vertical: -2),
    );
  }
}
