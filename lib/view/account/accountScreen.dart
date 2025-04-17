// import 'package:fidelityride/route/routePath.dart';
// import 'package:fidelityride/theme/colors.dart';
// import 'package:fidelityride/view/home/mainScreen.dart';
// import 'package:fidelityride/widget/defaultButton.dart';
// import 'package:flutter/material.dart';
//
// class AccountScreen extends StatelessWidget {
//   const AccountScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColor.backgroundColor,
//       appBar: AppBar(
//         title: const Text(
//           "Account",
//           style: TextStyle(
//             fontSize: 26,
//             fontWeight: FontWeight.bold,
//             color: Colors.black,
//           ),
//         ),
//         backgroundColor: Colors.white,
//         foregroundColor: Colors.black,
//         elevation: 0,
//       ),
//       body: ListView(
//         padding: const EdgeInsets.all(16),
//         children: [
//           _buildProfileSection(context),
//           const SizedBox(height: 20),
//           _buildOption(
//             icon: Icons.person_outline,
//             label: "Edit Profile",
//             onTap: () {},
//           ),
//           _buildOption(
//             icon: Icons.payment_outlined,
//             label: "Payment Methods",
//             onTap: () {},
//           ),
//           _buildOption(
//             icon: Icons.history,
//             label: "Ride History",
//             onTap: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (_) => MainScreen(initialIndex: 2)),
//               );
//             },
//           ),
//           _buildOption(
//             icon: Icons.local_offer_outlined,
//             label: "Promos & Coupons",
//             onTap: () {},
//           ),
//           _buildOption(
//             icon: Icons.support_agent_outlined,
//             label: "Support / Help Center",
//             onTap: () {},
//           ),
//           _buildOption(
//             icon: Icons.privacy_tip_outlined,
//             label: "Privacy Policy",
//             onTap: () {},
//           ),
//           _buildOption(
//             icon: Icons.logout,
//             label: "Logout",
//             onTap: () => _showLogoutDialog(context),
//           ),
//         ],
//       ),
//     );
//   }
//
//   void _showLogoutDialog(BuildContext context) {
//     showModalBottomSheet(
//       backgroundColor: AppColor.backgroundColor,
//       context: context,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
//       ),
//       isScrollControlled: true,
//       builder: (_) {
//         return Padding(
//           padding: const EdgeInsets.fromLTRB(16, 24, 16, 32),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Center(
//                 child: Container(
//                   width: 40,
//                   height: 4,
//                   decoration: BoxDecoration(
//                     color: Colors.grey[400],
//                     borderRadius: BorderRadius.circular(2),
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 24),
//               const Text(
//                 "Log out?",
//                 style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//               ),
//
//               const SizedBox(height: 8),
//               const Text(
//                 "Are you sure you want to log out from the Fidelity SafeRide App?",
//                 style: TextStyle(color: Colors.black54),
//                 textAlign: TextAlign.justify,
//               ),
//               const SizedBox(height: 24),
//
//               DefaultButton(
//                 text: "Logout",
//                 press: () {
//                   Navigator.pop(context); // close bottom sheet
//
//                   // TODO: Clear local storage / token here
//
//                   // Navigate to Auth screen
//                   Navigator.of(
//                     context,
//                   ).pushNamedAndRemoveUntil(RoutePath.auth, (route) => false);
//                 },
//                 borderRadius: 25,
//               ),
//               const SizedBox(height: 12),
//
//               DefaultButton(
//                 text: "Go Back",
//                 press: () {
//                   Navigator.pop(context);
//                 },
//                 borderRadius: 25,
//
//                 backgroundColor: AppColor.whiteColor,
//                 borderColor: AppColor.greyText,
//                 textColor: AppColor.greyText,
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
//
//   Widget _buildProfileSection(BuildContext context) {
//     return Row(
//       children: [
//         const CircleAvatar(
//           radius: 30,
//           backgroundImage: AssetImage(
//             'assets/images/1.jpg',
//           ), // replace with user's image
//         ),
//         const SizedBox(width: 16),
//         Expanded(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: const [
//               Text(
//                 "John Doe",
//                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//               ),
//               SizedBox(height: 4),
//               Text("+27 82 123 4567", style: TextStyle(color: Colors.grey)),
//             ],
//           ),
//         ),
//         IconButton(
//           icon: Icon(Icons.edit),
//           onPressed: () {
//             // navigate to profile editing screen
//           },
//         ),
//       ],
//     );
//   }
//
//   Widget _buildOption({
//     required IconData icon,
//     required String label,
//     required VoidCallback onTap,
//   }) {
//     return ListTile(
//       contentPadding: EdgeInsets.symmetric(vertical: 4),
//       leading: Icon(icon, size: 24, color: AppColor.mainColor),
//       title: Text(label, style: TextStyle(fontSize: 16)),
//       trailing: Icon(
//         Icons.arrow_forward_ios,
//         size: 18,
//         color: AppColor.blackColor,
//       ),
//       onTap: onTap,
//     );
//   }
// }

import 'package:fidelityride/route/routePath.dart';
import 'package:fidelityride/theme/colors.dart';
import 'package:fidelityride/view/home/mainScreen.dart';
import 'package:fidelityride/widget/defaultButton.dart';
import 'package:flutter/material.dart';

// Enhanced Account Screen with improved UI/UX and additional options
class AccountScreen extends StatelessWidget {
  const AccountScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.backgroundColor,
      appBar: AppBar(
        title: const Text(
          'Account',
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Profile header with gradient background and stats
            Container(
              margin: EdgeInsets.all(16),
              width: double.infinity,
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColor.mainColor,

                borderRadius: BorderRadius.circular(25),
              ),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 40,
                    backgroundImage: AssetImage('assets/images/1.jpg'),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'John Doe',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          '+27 82 123 4567',
                          style: TextStyle(fontSize: 16, color: Colors.white70),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.white),
                    onPressed:
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => EditProfileScreen(),
                          ),
                        ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  // Wallet & Earnings
                  _buildCardOption(
                    context,
                    icon: Icons.account_balance_wallet,
                    label: 'Wallet & Earnings',
                    onTap:
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => WalletScreen()),
                        ),
                  ),
                  _buildCardOption(
                    context,
                    icon: Icons.history,
                    label: 'Ride History',
                    onTap:
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => MainScreen(initialIndex: 2),
                          ),
                        ),
                  ),
                  _buildCardOption(
                    context,
                    icon: Icons.payment,
                    label: 'Payment Methods',
                    onTap:
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => PaymentMethodsScreen(),
                          ),
                        ),
                  ),
                  _buildCardOption(
                    context,
                    icon: Icons.local_offer,
                    label: 'Promos & Coupons',
                    onTap:
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => PromosCouponsScreen(),
                          ),
                        ),
                  ),
                  _buildCardOption(
                    context,
                    icon: Icons.card_giftcard,
                    label: 'Refer & Earn',
                    onTap:
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ReferAndEarnScreen(),
                          ),
                        ),
                  ),
                  _buildCardOption(
                    context,
                    icon: Icons.notifications,
                    label: 'Notification Settings',
                    onTap:
                        () => Navigator.of(
                          context,
                        ).pushNamed(RoutePath.notification),
                  ),

                  const Divider(height: 32),
                  // Support & Legal
                  _buildCardOption(
                    context,
                    icon: Icons.support_agent,
                    label: 'Support / Help Center',
                    onTap:
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => SupportScreen()),
                        ),
                  ),
                  _buildCardOption(
                    context,
                    icon: Icons.privacy_tip,
                    label: 'Privacy Policy',
                    onTap:
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => PrivacyPolicyScreen(),
                          ),
                        ),
                  ),
                  _buildCardOption(
                    context,
                    icon: Icons.description,
                    label: 'Terms & Conditions',
                    onTap:
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => TermsConditionsScreen(),
                          ),
                        ),
                  ),

                  _buildCardOption(
                    context,
                    icon: Icons.logout_rounded,
                    label: 'Log out',
                    onTap: () => _showLogoutDialog(context),
                  ),

                  // const SizedBox(height: 16),
                  // _buildLogoutButton(context),
                  //
                  // const SizedBox(height: 16),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCardOption(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: AppColor.whiteColor,
      elevation: 2,
      child: ListTile(
        leading: Icon(icon, color: AppColor.mainColor),
        title: Text(
          label,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showModalBottomSheet(
      backgroundColor: AppColor.backgroundColor,
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      isScrollControlled: true,
      builder: (_) => LogoutDialog(),
    );
  }
}

// Common dialog for logout confirmation
class LogoutDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[400],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Log out?',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'Are you sure you want to log out from the Fidelity SafeRide App?',
            style: TextStyle(color: Colors.black54, fontSize: 14),
          ),
          const SizedBox(height: 24),
          DefaultButton(
            text: 'Logout',
            press: () {
              Navigator.pop(context);
              Navigator.of(
                context,
              ).pushNamedAndRemoveUntil(RoutePath.auth, (route) => false);
            },
            borderRadius: 25,
          ),
          const SizedBox(height: 12),
          DefaultButton(
            text: 'Go Back',
            press: () => Navigator.pop(context),
            borderRadius: 25,
            backgroundColor: AppColor.whiteColor,
            borderColor: AppColor.greyText,
            textColor: AppColor.greyText,
          ),
        ],
      ),
    );
  }
}

// Dummy Screens for each option
class EditProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.backgroundColor,

      appBar: AppBar(title: const Text('Edit Profile')),
      body: const Center(child: Text('Edit Profile Screen')),
    );
  }
}

class WalletScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.backgroundColor,

      appBar: AppBar(title: const Text('Wallet & Earnings')),
      body: const Center(child: Text('Wallet Screen')),
    );
  }
}

class PaymentMethodsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.backgroundColor,

      appBar: AppBar(title: const Text('Payment Methods')),
      body: const Center(child: Text('Payment Methods Screen')),
    );
  }
}

class PromosCouponsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.backgroundColor,

      appBar: AppBar(title: const Text('Promos & Coupons')),
      body: const Center(child: Text('Promos & Coupons Screen')),
    );
  }
}

class ReferAndEarnScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.backgroundColor,

      appBar: AppBar(title: const Text('Refer & Earn')),
      body: const Center(child: Text('Refer & Earn Screen')),
    );
  }
}

class SupportScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.backgroundColor,

      appBar: AppBar(title: const Text('Support / Help Center')),
      body: const Center(child: Text('Support Screen')),
    );
  }
}

class PrivacyPolicyScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.backgroundColor,
      appBar: AppBar(title: const Text('Privacy Policy')),
      body: Center(child: Text('Privacy Policy content here')),
    );
  }
}

class TermsConditionsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.backgroundColor,

      appBar: AppBar(title: const Text('Terms & Conditions')),
      body: Center(child: Text('Terms & Conditions content here')),
    );
  }
}
