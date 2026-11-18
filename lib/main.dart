import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:hotelapps/ui/screens/onboarding.dart';
import 'package:hotelapps/ui/screens/login.dart';
import 'package:hotelapps/ui/screens/home.dart';

//menghubungkan Supabase di main.dart
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://uafdfrdbmnjggltqskmo.supabase.co', //Project URL yg dibuat di Supabase
    publishableKey: 'sb_publishable_fFKlSLFh91hf30MJynqDlQ_fIUa8j-j', //API Key nya
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const OnboardingPage(),
    );
  }
}