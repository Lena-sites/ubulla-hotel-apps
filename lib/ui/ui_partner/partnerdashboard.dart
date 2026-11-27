import 'package:flutter/material.dart';
import 'package:hotelapps/ui/ui_partner/myhotels.dart';

class PartnerDashboard extends StatelessWidget {
  const PartnerDashboard({super.key});

  static const Color primaryGreen = Color(0xFF10B981);
  static const Color darkGreen = Color(0xFF047857);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9F8),
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF1F2937),
        elevation: 0,
        title: const Text(
          'UBULLA Partner',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications_none_rounded),
          ),
          const SizedBox(width: 8),
        ],
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome Section
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [primaryGreen, darkGreen],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.waving_hand_rounded,
                      color: Colors.white,
                      size: 30,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Welcome, Partner!',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 23,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Manage your properties and reservations with UBULLA.',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 14,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              const Text(
                'Your Business',
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1F2937),
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Manage your hotel activities',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 13,
                ),
              ),

              const SizedBox(height: 18),

              // My Hotels
              Card(
                color: Colors.white,
                elevation: 1,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  leading: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: primaryGreen.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(
                      Icons.apartment_rounded,
                      color: primaryGreen,
                      size: 25,
                    ),
                  ),
                  title: const Text(
                    'My Hotels',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: const Text(
                    'Manage your hotel information, rooms, and prices.',
                  ),
                  trailing: const Icon(Icons.chevron_right_rounded),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MyHotelsPage(),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 14),

              // Reservation Reports
              Card(
                color: Colors.white,
                elevation: 1,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  leading: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: primaryGreen.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(
                      Icons.receipt_long_rounded,
                      color: primaryGreen,
                      size: 25,
                    ),
                  ),
                  title: const Text(
                    'Reservation Reports',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: const Text(
                    'View incoming reservations and booking details.',
                  ),
                  trailing: const Icon(Icons.chevron_right_rounded),
                  onTap: () {},
                ),
              ),

              const SizedBox(height: 28),

              const Text(
                'Account',
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1F2937),
                ),
              ),

              const SizedBox(height: 14),

              // My Profile
              Card(
                color: Colors.white,
                elevation: 1,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  leading: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(
                      Icons.person_outline_rounded,
                      color: Colors.blue,
                      size: 25,
                    ),
                  ),
                  title: const Text(
                    'My Profile',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: const Text(
                    'Manage your account information.',
                  ),
                  trailing: const Icon(Icons.chevron_right_rounded),
                  onTap: () {},
                ),
              ),

              const SizedBox(height: 14),

              // Logout
              Card(
                color: Colors.white,
                elevation: 1,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  leading: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(
                      Icons.logout_rounded,
                      color: Colors.red,
                      size: 25,
                    ),
                  ),
                  title: const Text(
                    'Logout',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                  subtitle: const Text(
                    'Sign out from your partner account.',
                  ),
                  trailing: const Icon(Icons.chevron_right_rounded),
                  onTap: () {},
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
