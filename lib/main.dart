import 'package:flutter/material.dart';
import 'package:hotelapps/ui/authentication/resetpassword.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:hotelapps/ui/screens/onboarding.dart';
import 'package:hotelapps/services/auth_state.dart';

final navigatorKey = GlobalKey<NavigatorState>();

//menghubungkan Supabase di main.dart
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://uafdfrdbmnjggltqskmo.supabase.co', //Project URL yg dibuat di Supabase
    publishableKey: 'sb_publishable_fFKlSLFh91hf30MJynqDlQ_fIUa8j-j', //API Key nya
    authOptions: const FlutterAuthClientOptions(
      authFlowType: AuthFlowType.implicit,
    ),
  );

  runApp(const MyApp());
}

class MyApp extends StatefulWidget{
  const MyApp ({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp>{
  @override
  void initState(){
    super.initState();

    Supabase.instance.client.auth.onAuthStateChange.listen((data){
      // debugPrint('AUTH EVENT: ${data.event}');
      if (data.event == AuthChangeEvent.passwordRecovery) {
        isPasswordRecovery = true;
        _goToReset();
      }
    });
    // Kalau flag sudah true dari cek URL, langsung arahkan setelah frame pertama
    if (isPasswordRecovery) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _goToReset());
    }
  }

  void _goToReset(){
    navigatorKey.currentState?.pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const ResetPasswordPage()),(route) =>false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      home: const OnboardingPage(),
    );
  }
}




