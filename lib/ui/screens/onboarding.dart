import 'package:flutter/material.dart';
import 'package:hotelapps/ui/screens/onboarding2.dart';
import 'package:hotelapps/ui/screens/home.dart';
import 'package:hotelapps/ui/authentication/login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:hotelapps/ui/authentication/resetpassword.dart';
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

    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => nextPage),
    );
  }

  @override
  Widget build(BuildContext context) {

    //dark atau light mode
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF121212) : Colors.white;
    final textColor = Theme.of(context).colorScheme.onSurface;

    return Scaffold(
      backgroundColor: bgColor,
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
                          color: textColor,
                        ),
                      ),
                      Text(
                        'Hotel and Resort',
                        style: TextStyle(
                          fontFamily: 'Cormorant_Garamond',
                          fontSize: 14,
                          color: textColor,
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
