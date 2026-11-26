import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:hotelapps/ui/screens/onboarding.dart';
import 'package:hotelapps/ui/ui_admin/hotelmanagement.dart';
import 'package:hotelapps/ui/ui_admin/customermanagement.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboard();
}

class _AdminDashboard extends State<AdminDashboard> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: SafeArea(
        child: Column(
          children: [
            // HEADER
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 18,
              ),
              decoration: const BoxDecoration(
                color: Color(0xFF10A05A),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(25),
                  bottomRight: Radius.circular(25),
                ),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.dashboard,
                    color: Colors.white,
                    size: 26,
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'Dashboard',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (dialogContext) => AlertDialog(
                          title: const Text('Logout'),
                          content: const Text(
                            'Are you sure you want to logout?',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(dialogContext);
                              },
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () async {
                                Navigator.pop(dialogContext);

                                await Supabase.instance.client.auth.signOut();

                                if (!mounted) return;

                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const OnboardingPage(),
                                  ),
                                      (route) => false,
                                );
                              },
                              child: const Text(
                                'Logout',
                                style: TextStyle(
                                  color: Colors.red,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                    icon: const Icon(
                      Icons.power_settings_new,
                      color: Colors.white,
                      size: 25,
                    ),
                  ),
                ],
              ),
            ),

            // PROFILE CARD
            Transform.translate(
              offset: const Offset(0, -5),
              child: Container(
                width: double.infinity,
                margin: const EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.12),
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Welcome, Admin!',
                            style: TextStyle(
                              color: Color(0xFF10A05A),
                              fontSize: 19,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 6),
                          Text(
                            'UBULLA Hotel and Resort',
                            style: TextStyle(
                              color: Colors.black87,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const CircleAvatar(
                      radius: 23,
                      backgroundColor: Color(0xFFE4F5EC),
                      child: Icon(
                        Icons.admin_panel_settings,
                        color: Color(0xFF10A05A),
                        size: 28,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 15),

            // MENU ADMIN
            Expanded(
              child: Center(
                child: Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 15,
                  runSpacing: 15,
                  children: [
                    // PARTNER APPROVAL
                    GestureDetector(
                      onTap: () {
                        // Navigasi Partner Approval nanti
                      },
                      child: Container(
                        width: 125,
                        height: 125,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.12),
                              blurRadius: 5,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              radius: 22,
                              backgroundColor: Color(0xFF10A05A),
                              child: Icon(
                                Icons.handshake,
                                color: Colors.white,
                                size: 25,
                              ),
                            ),
                            SizedBox(height: 12),
                            Text(
                              'PARTNER\nAPPROVAL',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Color(0xFF10A05A),
                                fontWeight: FontWeight.bold,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // HOTEL MANAGEMENT
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const HotelManagementPage(),
                          ),
                        );
                      },
                      child: Container(
                        width: 125,
                        height: 125,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.12),
                              blurRadius: 5,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              radius: 22,
                              backgroundColor: Color(0xFF10A05A),
                              child: Icon(
                                Icons.hotel,
                                color: Colors.white,
                                size: 25,
                              ),
                            ),
                            SizedBox(height: 12),
                            Text(
                              'HOTEL\nMANAGEMENT',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Color(0xFF10A05A),
                                fontWeight: FontWeight.bold,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // CUSTOMER MANAGEMENT
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const CustomerManagementPage(),
                          ),
                        );
                      },
                      child: Container(
                        width: 125,
                        height: 125,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.12),
                              blurRadius: 5,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              radius: 22,
                              backgroundColor: Color(0xFF10A05A),
                              child: Icon(
                                Icons.people,
                                color: Colors.white,
                                size: 25,
                              ),
                            ),
                            SizedBox(height: 12),
                            Text(
                              'CUSTOMER\nMANAGEMENT',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Color(0xFF10A05A),
                                fontWeight: FontWeight.bold,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}