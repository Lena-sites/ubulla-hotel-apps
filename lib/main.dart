import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:hotelapps/ui/screens/onboarding.dart';
import 'package:hotelapps/services/auth_state.dart';

//menghubungkan Supabase di main.dart
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://uafdfrdbmnjggltqskmo.supabase.co', //Project URL yg dibuat di Supabase
    publishableKey: 'sb_publishable_fFKlSLFh91hf30MJynqDlQ_fIUa8j-j', //API Key nya
  );

  final supabase = Supabase.instance.client;

  supabase.auth.onAuthStateChange.listen((data) {
    debugPrint('AUTH EVENT: ${data.event}');

    if (data.event == AuthChangeEvent.passwordRecovery) {
      isPasswordRecovery = true;
      debugPrint('PASSWORD RECOVERY DETECTED!');
    }
  });

// Proses callback reset password secara manual
  final callbackUri = Uri.base;

  debugPrint('CALLBACK HAS CODE: ${callbackUri.queryParameters.containsKey('code')}');
  debugPrint('CALLBACK PATH: ${callbackUri.path}');
  debugPrint('CALLBACK TYPE: ${callbackUri.queryParameters['type'] ?? 'none'}');

  // if (callbackUri.queryParameters.containsKey('code')) {
  //   try {
  //     await supabase.auth.getSessionFromUrl(callbackUri);
  //     debugPrint('RECOVERY CALLBACK PROCESSED!');
  //   } on AuthException catch (e) {
  //     debugPrint('RECOVERY CALLBACK ERROR: ${e.message}');
  //   }
  // }

  // Mendeteksi proses reset password dari email
  // Supabase.instance.client.auth.onAuthStateChange.listen(
  //       (data) {
  //     debugPrint('AUTH EVENT: ${data.event}');
  //
  //     if (data.event == AuthChangeEvent.passwordRecovery) {
  //       isPasswordRecovery = true;
  //       debugPrint('PASSWORD RECOVERY DETECTED!');
  //     }
  //   },
  // );
  // Supabase.instance.client.auth.onAuthStateChange.listen(
  //   (data){
  //     if (data.event == AuthChangeEvent.passwordRecovery){
  //       isPasswordRecovery = true;
  //     }
  //   },
  // );


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