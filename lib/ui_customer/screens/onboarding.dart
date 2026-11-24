import 'package:flutter/material.dart';
import 'package:hotelapps/ui_customer/screens/onboarding2.dart';
import 'package:hotelapps/ui_customer/screens/home.dart';
import 'package:hotelapps/ui_customer/authentication/login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:hotelapps/ui_customer/authentication/resetpassword.dart';
import 'package:hotelapps/services/auth_state.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  // Variabel onboarding
  bool showLogo = false;
  bool showLoading = false;

  @override
  void initState() {
    super.initState();

    // Animasi logo muncul setelah 300 ms
    Future.delayed(Duration(milliseconds: 300), () {
      if (!mounted) return;
      setState(() => showLogo = true);
    });

    // Loading muncul setelah 1300 ms
    Future.delayed(Duration(milliseconds: 1300), () {
      if (!mounted) return;
      setState(() => showLoading = true);
    });

    // Navigasi setelah splash screen selesai
    navigateAfterSplash();
  }

  // Fungsi menentukan halaman selanjutnya
  Future<void> navigateAfterSplash() async {
    await Future.delayed(Duration(seconds: 3));

    if (!mounted) return;

    final prefs = await SharedPreferences.getInstance();

    final hasSeenOnboarding =
        prefs.getBool('hasSeenOnboarding') ?? false;

    final session = Supabase.instance.client.auth.currentSession;

    Widget nextPage;

    if (isPasswordRecovery) {
      // Jika pengguna sedang reset password
      nextPage = ResetPasswordPage();

    } else if (session != null) {
      // Jika sudah login
      nextPage = HomePage();

    } else if (hasSeenOnboarding) {
      // Jika sudah pernah onboarding
      nextPage = LoginPage();

    } else {
      // Jika pertama kali membuka aplikasi
      nextPage = Onboarding2();
    }

    // if (session != null) {
    //   // Jika sudah login, langsung ke Home
    //   nextPage = const HomePage();
    // } else if (hasSeenOnboarding) {
    //   // Jika sudah onboarding tetapi belum login
    //   nextPage = const LoginPage();
    // } else {
    //   // Jika pertama kali membuka aplikasi
    //   nextPage = const Onboarding2();
    // }
    // debugPrint('RECOVERY FLAG: $isPasswordRecovery');
    // debugPrint('CURRENT SESSION: ${session != null}');

    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => nextPage),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo dan tulisan dengan animasi
              AnimatedOpacity(
                opacity: showLogo ? 1.0 : 0.0,
                duration: Duration(milliseconds: 1000),
                child: AnimatedScale(
                  scale: showLogo ? 1.0 : 0.5,
                  duration: Duration(milliseconds: 1000),
                  curve: Curves.easeOutBack,
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(24),
                        child: Image.asset(
                          'assets/images/logo.png',
                          width: 120,
                          height: 120,
                        ),
                      ),
                      SizedBox(height: 16),
                      Text(
                        'UBULLA',
                        style: TextStyle(
                          fontFamily: 'Cormorant_Garamond',
                          fontSize: 32,
                        ),
                      ),
                      Text(
                        'Hotel and Resort',
                        style: TextStyle(
                          fontFamily: 'Cormorant_Garamond',
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 40),

              // Loading animation
              AnimatedOpacity(
                opacity: showLoading ? 1.0 : 0.0,
                duration: Duration(milliseconds: 500),
                child: SizedBox(
                  width: 30,
                  height: 30,
                  child: CircularProgressIndicator(
                    color: Color(0xFF10B981),
                    strokeWidth: 3,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
