import 'package:flutter/material.dart';
import 'package:hotelapps/booking.dart';
import 'package:hotelapps/main.dart';
import 'package:hotelapps/search.dart';

// void main() {
//   runApp(const ProfileApp());
// }

// class ProfileApp extends StatelessWidget {
//   const ProfileApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: ProfilePage(),
//     );
//   }
// }

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // variabel kondisi untuk gesture
  bool isDark = false;

  @override
  Widget build(BuildContext context) {
    // mengambil ukuran layar
    final screenWidth = MediaQuery.of(context).size.width;
    //jika lebar >600 dianggap layarnya lebar/besar
    final isLargeScreen = screenWidth > 600;

    // warna ikut dark theme
    final bgColor = isDark ? Colors.black : Colors.grey.shade200;
    final cardColor = isDark ? Colors.grey.shade900 : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black87;
    final subTextColor = isDark ? Colors.white70 : Colors.black54;

    // profile
    final avatar = Stack(
      children: [
        ClipOval(
          // foto dari asset
          child: Image.asset(
            'assets/images/profile.jpg',
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
          'Li Shen',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
        SizedBox(height: 4),
        Text(
          'lishen@lnds.com',
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
                    Text(
                      'Profile',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
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

                // menu edit profile
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.only(bottom: 10),
                  padding: EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.person_outline, color: textColor, size: 22),
                      SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          'Edit Profile',
                          style: TextStyle(fontSize: 15, color: textColor),
                        ),
                      ),
                    ],
                  ),
                ),

                // menu payment
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.only(bottom: 10),
                  padding: EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.account_balance_wallet_outlined, color: textColor, size: 22),
                      SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          'Payment',
                          style: TextStyle(fontSize: 15, color: textColor),
                        ),
                      ),
                    ],
                  ),
                ),

                // menu notifications
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.only(bottom: 10),
                  padding: EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.notifications_none, color: textColor, size: 22),
                      SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          'Notifications',
                          style: TextStyle(fontSize: 15, color: textColor),
                        ),
                      ),
                    ],
                  ),
                ),

                // menu security
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.only(bottom: 10),
                  padding: EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.shield_outlined, color: textColor, size: 22),
                      SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          'Security',
                          style: TextStyle(fontSize: 15, color: textColor),
                        ),
                      ),
                    ],
                  ),
                ),

                // menu help
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.only(bottom: 10),
                  padding: EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.info_outline, color: textColor, size: 22),
                      SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          'Help',
                          style: TextStyle(fontSize: 15, color: textColor),
                        ),
                      ),
                    ],
                  ),
                ),

                // menu dark theme
                // teken biar theme berubah
                GestureDetector(
                  onTap: () {
                    setState(() {
                      isDark = !isDark;
                    });
                  },
                  child: Container(
                    width: double.infinity,
                    margin: EdgeInsets.only(bottom: 10),
                    padding: EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                    decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.remove_red_eye_outlined, color: textColor, size: 22),
                        SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            'Dark Theme',
                            style: TextStyle(fontSize: 15, color: textColor),
                          ),
                        ),
                        darkSwitch,
                      ],
                    ),
                  ),
                ),

                // menu logout
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.only(bottom: 10),
                  padding: EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.logout, color: Colors.redAccent, size: 22),
                      SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          'Logout',
                          style: TextStyle(fontSize: 15, color: Colors.redAccent),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 3,
        type: BottomNavigationBarType.fixed,
        backgroundColor: cardColor,
        selectedItemColor: Color(0xFF10B981),
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          if(index == 0){
            Navigator.push(context, MaterialPageRoute(builder: (context) => const HomePage()),
            );
          } else if (index == 1){
            Navigator.push(context, MaterialPageRoute(builder: (context) => const SearchPage()),
            );
          } else if (index == 2){
            Navigator.push(context, MaterialPageRoute(builder: (context) => const BookingPage()),
            );
          } else if (index == 3){
            Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfilePage()),
            );
          }
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(icon: Icon(Icons.receipt_long_outlined), label: 'Booking'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}