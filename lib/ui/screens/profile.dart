// import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:hotelapps/ui/widgets/navigation.dart';
import 'package:hotelapps/ui/authentication/login.dart';
import 'package:hotelapps/services/theme_controller.dart';
import 'package:hotelapps/ui/screens/editpayment.dart';
import 'package:hotelapps/ui/screens/help.dart';

import 'editprofile.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  @override
  Widget build(BuildContext context) {
    // mengambil ukuran layar
    final screenWidth = MediaQuery.of(context).size.width;
    //jika lebar >600 dianggap layarnya lebar/besar
    final isLargeScreen = screenWidth > 600;

    final isDark = Theme.of(context).brightness == Brightness.dark;

    // warna ikut dark theme
    final bgColor = isDark ? const Color(0xFF121212) : Colors.grey.shade200;
    final cardColor = Theme.of(context).cardColor;
    final textColor = Theme.of(context).colorScheme.onSurface;
    final subTextColor = isDark ? Colors.white70 : Colors.black54;
    final dividerColor = isDark ? Colors.white12 : Colors.black12;

    // profile
    final avatar = Stack(
      children: [
        ClipOval(
          // foto dari asset
          child: Image.asset(
            'assets/images/profil.jpg',
            width: 120,
            height: 120,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                width: 120,
                height: 120,
                color: Colors.grey.shade300,
                child: Center(
                  child: Text('Foto belum ada', style: TextStyle(fontSize: 11)),
                ),
              );
            },
          ),
        ),
        Positioned(
          right: 4,
          bottom: 4,
          child: Container(
            padding: EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Color(0xFF10B981),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: bgColor, width: 2),
            ),
            child: Icon(Icons.edit, color: Colors.white, size: 14),
          ),
        ),
      ],
    );
    // nama email
    final namaEmail = Column(
      crossAxisAlignment:
      isLargeScreen ? CrossAxisAlignment.start : CrossAxisAlignment.center,
      children: [
        Text(
          'Lena',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
        SizedBox(height: 4),
        Text(
          'lena@gmail.com',
          style: TextStyle(fontSize: 13, color: subTextColor),
        ),
      ],
    );
    // tombol dark theme
    final darkSwitch = Container(
      width: 44,
      height: 24,
      decoration: BoxDecoration(
        color: isDark ? Color(0xFF10B981) : Colors.grey.shade400,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Stack(
        children: [
          // buat geser
          Positioned(
            left: isDark ? 22 : 2,
            top: 2,
            child: Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      ),
    );
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: Colors.grey,
        title: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                'assets/images/logo.png',
                width: 40,
                height: 40,
              ),
            ),
            SizedBox(width: 5),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'UBULLA',
                  style: TextStyle(fontFamily: 'Cormorant_Garamond', fontSize: 18),
                ),
                Text(
                  'Hotel and Resort',
                  style: TextStyle(fontFamily: 'Cormorant_Garamond', fontSize: 9),
                ),
              ],
            ),
            Spacer(),
            Icon(Icons.notifications_none_outlined),
            SizedBox(width: 2),
            Icon(Icons.bookmark_outline),
          ],
        ),
        automaticallyImplyLeading: false, //matiin tanda panah back otomatis
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                // judul halaman
                Row(
                  children: [
                    Text('Profile', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: textColor,)),
                    Spacer(),
                    Container(
                      padding: EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: textColor, width: 1.5),
                      ),
                      child: Icon(Icons.more_horiz, size: 18, color: textColor),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                // profile agar sesuai layar
                Flex(
                  direction: isLargeScreen ? Axis.horizontal : Axis.vertical,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    avatar,
                    SizedBox(
                      width: isLargeScreen ? 24 : 0,
                      height: isLargeScreen ? 0 : 16,
                    ),
                    namaEmail,
                  ],
                ),

                SizedBox(height: 24),

                // ===== KATEGORI PERSONAL =====
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.only(left: 4, bottom: 8),
                    child: Text(
                      'Personal',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: subTextColor,
                      ),
                    ),
                  ),
                ),
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      // menu edit profile
                      GestureDetector(
                        onTap: ()async {
                          final result = await showEditProfileDialog(context);
                          if (result == true && mounted) {
                            setState(() {});
                          }
                        },
                        child: Container(
                          width: double.infinity,
                          padding:
                          EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                          child: Row(
                            children: [
                              Icon(Icons.person_outline,
                                  color: textColor, size: 22),
                              SizedBox(width: 16),
                              Expanded(
                                child: Text(
                                  'Edit Profile',
                                  style:
                                  TextStyle(fontSize: 15, color: textColor),
                                ),
                              ),
                              Icon(Icons.chevron_right, color: Colors.grey, size: 22),
                            ],
                          ),
                        ),
                      ),
                      Divider(height: 1, color: dividerColor),

                      GestureDetector(
                        onTap: () async{
                          await showEditPaymentDialog(context);
                        },
                        child: Container(
                          width: double.infinity,
                          padding:
                          EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                          child: Row(
                            children: [
                              Icon(Icons.account_balance_wallet_outlined,
                                  color: textColor, size: 22),
                              SizedBox(width: 16),
                              Expanded(
                                child: Text(
                                  'Payment',
                                  style:
                                  TextStyle(fontSize: 15, color: textColor),
                                ),
                              ),
                              Icon(Icons.chevron_right, color: Colors.grey, size: 22),
                            ],
                          ),
                        ),
                      ),
                      // menu payment
                      Divider(height: 1, color: dividerColor),
                    ],
                  ),
                ),

                // // ===== KATEGORI DATA & SECURITY =====
                // Align(
                //   alignment: Alignment.centerLeft,
                //   child: Padding(
                //     padding: EdgeInsets.only(left: 4, bottom: 8),
                //     child: Text(
                //       'Data & Security',
                //       style: TextStyle(
                //         fontSize: 13,
                //         fontWeight: FontWeight.bold,
                //         color: subTextColor,
                //       ),
                //     ),
                //   ),
                // ),
                // Container(
                //   width: double.infinity,
                //   margin: EdgeInsets.only(bottom: 16),
                //   decoration: BoxDecoration(
                //     color: cardColor,
                //     borderRadius: BorderRadius.circular(10),
                //   ),
                //   child: Column(
                //     children: [
                //       // menu security
                //       Container(
                //         width: double.infinity,
                //         padding:
                //         EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                //         child: Row(
                //           children: [
                //             Icon(Icons.shield_outlined,
                //                 color: textColor, size: 22),
                //             SizedBox(width: 16),
                //             Expanded(
                //               child: Text(
                //                 'Security',
                //                 style:
                //                 TextStyle(fontSize: 15, color: textColor),
                //               ),
                //             ),
                //             Icon(Icons.chevron_right, color: Colors.grey, size: 22),
                //           ],
                //         ),
                //       ),
                //     ],
                //   ),
                // ),

                // ===== KATEGORI PREFERENCES =====
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.only(left: 4, bottom: 8),
                    child: Text(
                      'Preferences',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: subTextColor,
                      ),
                    ),
                  ),
                ),
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      // menu help
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const HelpPage(),
                            ),
                          );
                        },
                        child: Container(
                          width: double.infinity,
                          padding:
                          EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                          child: Row(
                            children: [
                              Icon(Icons.info_outline,
                                  color: textColor, size: 22),
                              SizedBox(width: 16),
                              Expanded(
                                child: Text(
                                  'Help',
                                  style:
                                  TextStyle(fontSize: 15, color: textColor),
                                ),
                              ),
                              Icon(Icons.chevron_right, color: Colors.grey, size: 22),
                            ],
                          ),
                        ),
                      ),
                      Divider(height: 1, color: dividerColor),
                      // menu dark theme
                      // teken biar theme berubah
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            ThemeController.setTheme(
                              isDark ? ThemeMode.light : ThemeMode.dark,
                            );
                          });
                        },
                        child: Container(
                          width: double.infinity,
                          color: Colors.transparent,
                          padding: EdgeInsets.symmetric(
                              horizontal: 14, vertical: 14),
                          child: Row(
                            children: [
                              Icon(Icons.remove_red_eye_outlined,
                                  color: textColor, size: 22),
                              SizedBox(width: 16),
                              Expanded(
                                child: Text(
                                  'Dark Theme',
                                  style:
                                  TextStyle(fontSize: 15, color: textColor),
                                ),
                              ),
                              darkSwitch,
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // menu logout
                GestureDetector(
                  onTap: () async {
                    // Konfirmasi logout
                    final confirm = await showDialog<bool>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text('Logout'),
                        content: Text('Are you sure you want to logout?'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context, false);
                            },
                            child: Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context, true);
                            },
                            child: Text(
                              'Yes, Logout',
                              style: TextStyle(color: Colors.redAccent),
                            ),
                          ),
                        ],
                      ),
                    );

                    if (confirm == true) {
                      try {
                        await Supabase.instance.client.auth.signOut();

                        if (!mounted) return;

                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginPage(),
                          ),
                              (route) => false,
                        );
                      } catch (e) {
                        if (!mounted) return;

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Logout failed. Please try again.'),
                          ),
                        );
                      }
                    }
                  },
                  child: Container(
                    width: double.infinity,
                    margin: EdgeInsets.only(bottom: 10),
                    padding: EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 14,
                    ),
                    decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.logout,
                          color: Colors.redAccent,
                          size: 22,
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            'Logout',
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.redAccent,
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
        ),
      ),
      //tempat navigasi
      bottomNavigationBar: BottomNavigation(currentIndex: 3),
    );
  }
}