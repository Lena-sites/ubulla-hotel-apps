import 'package:flutter/material.dart';
import 'package:hotelapps/main.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  // variabel on boarding
  bool showLogo = false;
  bool showLoading = false;

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration(milliseconds: 300), () {
      if (!mounted) return;
      setState(() => showLogo = true);
    });

    Future.delayed(Duration(milliseconds: 1300), () {
      if (!mounted) return;
      setState(() => showLoading = true);
    });

    Future.delayed(Duration(seconds: 3), () {
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    });
  }

  // @override
  // void initState() {
  //   super.initState();
  //
  //   // 0.3s, muncul logo
  //   Future.delayed(Duration(milliseconds: 300), () {
  //     setState(() {
  //       showLogo = true;
  //     });
  //   });
  //
  //   // 1.3s, muncul loading
  //   Future.delayed(Duration(milliseconds: 1300), () {
  //     setState(() {
  //       showLoading = true;
  //     });
  //   });
  //
  //   // 3s, homepage
  //   Future.delayed(Duration(seconds: 3), () {
  //     Navigator.pushReplacement(
  //       context,
  //       MaterialPageRoute(builder: (context) => const HomePage()),
  //     );
  //   });
  // }

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
              // logo + tulisan, fade dan membesar pelan2
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
                        style: TextStyle(fontFamily: 'Cormorant_Garamond', fontSize: 32),
                      ),
                      Text(
                        'Hotel and Resort',
                        style: TextStyle(fontFamily: 'Cormorant_Garamond', fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 40),
              // loading muncul setelah logo
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