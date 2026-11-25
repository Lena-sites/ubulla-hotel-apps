import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:hotelapps/ui_customer/widgets/navigation.dart';
import 'package:hotelapps/ui_customer/authentication/login.dart';
import 'package:hotelapps/ui_customer/screens/editpayment.dart';
import 'package:hotelapps/ui_customer/screens/help.dart';
import 'package:hotelapps/ui_customer/screens/editprofile.dart';
import 'package:hotelapps/services/theme_controller.dart';
import 'package:hotelapps/services/user_service.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  final userService = UserService();

  Future<void> _changeProfilePhoto() async {
    final picker = ImagePicker();

    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (image == null) return;

    try {
      await userService.updateProfilePhoto(image);

      if (!mounted) return;

      setState(() {});

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Foto profil berhasil diperbarui!'),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal memperbarui foto: $e'),
        ),
      );
    }
  }

  Future<void> _deleteProfilePhoto() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Foto Profil'),
        content: const Text('Yakin ingin menghapus foto profil?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Hapus',
                style: TextStyle(color: Colors.redAccent)),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    try {
      await userService.deleteProfilePhoto();
      if (!mounted) return;
      setState(() {});
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Foto profil dihapus.')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menghapus foto: $e')),
      );
    }
  }

  void _showPhotoOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: const Text('Ganti foto'),
              onTap: () {
                Navigator.pop(context);
                _changeProfilePhoto();
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete_outline, color: Colors.redAccent),
              title: const Text('Hapus foto',
                  style: TextStyle(color: Colors.redAccent)),
              onTap: () {
                Navigator.pop(context);
                _deleteProfilePhoto();
              },
            ),
          ],
        ),
      ),
    );
  }



  @override
  Widget build(BuildContext context) {
    // mengambil ukuran layar
    final screenWidth = MediaQuery.of(context).size.width;
    //jika lebar >600 dianggap layarnya lebar/besar
    final isLargeScreen = screenWidth > 600;

    final isDark = Theme.of(context).brightness == Brightness.dark;

    //ambil hasil pengambilan di /services
    final username = userService.getUsername();
    final email = Supabase.instance.client.auth.currentUser?.email ?? '';
    final avatarUrl = userService.getProfilePhotoUrl();

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
          child: avatarUrl.startsWith('assets/')
              ? Image.asset(
            avatarUrl,
            width: 120,
            height: 120,
            fit: BoxFit.cover,
          )
              : Image.network(
            avatarUrl,
            width: 120,
            height: 120,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Image.asset(
                'assets/images/dummy.jpg',
                width: 120,
                height: 120,
                fit: BoxFit.cover,
              );
            },
          ),
        ),
        Positioned(
          right: 4,
          bottom: 4,
          child: GestureDetector(
            onTap: _showPhotoOptions,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                color: Colors.black,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.edit,
                color: Colors.white,
                size: 14,
              ),
            ),
          ),
        ),
      ],
    );
    // nama email
    final namaEmail = Column(
      crossAxisAlignment:
      isLargeScreen ? CrossAxisAlignment.start : CrossAxisAlignment.center,
      children: [
        Text(username, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: textColor,),),
        SizedBox(height: 4),
        Text(email, style: TextStyle(fontSize: 13, color: subTextColor),),
      ],
    );
    // tombol dark theme

    final darkSwitch = GestureDetector(
      onHorizontalDragEnd: (details) {
        if (details.primaryVelocity == null) return;

        if (details.primaryVelocity! > 0 && !isDark) {
          ThemeController.setTheme(ThemeMode.dark);
        } else if (details.primaryVelocity! < 0 && isDark) {
          ThemeController.setTheme(ThemeMode.light);
        }
      },
      onTap: () {
        ThemeController.setTheme(
          isDark ? ThemeMode.light : ThemeMode.dark,
        );
      },
      child: Container(
        width: 44,
        height: 24,
        decoration: BoxDecoration(
          color: isDark
              ? const Color(0xFF10B981)
              : Colors.grey.shade400,
          borderRadius: BorderRadius.circular(12),
        ),
        child: AnimatedAlign(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          alignment:
          isDark ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            width: 20,
            height: 20,
            margin: const EdgeInsets.symmetric(horizontal: 2),
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
          ),
        ),
      ),
    );


    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
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
                    ],
                  ),
                ),
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

                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 14,
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.remove_red_eye_outlined,
                              color: textColor,
                              size: 22,
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Text(
                                'Dark Theme',
                                style: TextStyle(
                                  fontSize: 15,
                                  color: textColor,
                                ),
                              ),
                            ),
                            darkSwitch,
                          ],
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