import 'package:flutter/material.dart';
import 'package:hotelapps/ui/authentication/resetpassword.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:hotelapps/ui/screens/onboarding.dart';
import 'package:hotelapps/services/auth_state.dart';
import 'package:hotelapps/services/theme_controller.dart';

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
  // mengambil preferensi tema yang tersimpan
  await ThemeController.loadTheme();

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
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: ThemeController.themeNotifier,
      builder: (context, currentTheme, child) {
        return MaterialApp(
          navigatorKey: navigatorKey,
          debugShowCheckedModeBanner: false,

          // LIGHT MODE
          theme: ThemeData(
            useMaterial3: true,
            brightness: Brightness.light,
            scaffoldBackgroundColor: Colors.white,
            colorScheme: const ColorScheme.light(
              primary: Colors.black,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black87,
            ),
            appBarTheme: const AppBarTheme(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              elevation: 0,
            ),
            cardColor: Colors.white,
            dividerColor: Colors.black12,
          ),

          // DARK MODE
          darkTheme: ThemeData(
            useMaterial3: true,
            brightness: Brightness.dark,
            scaffoldBackgroundColor: const Color(0xFF121212),
            colorScheme: const ColorScheme.dark(
              primary: Colors.white,
              onPrimary: Colors.black,
              surface: Color(0xFF1E1E1E),
              onSurface: Colors.white,
            ),
            appBarTheme: const AppBarTheme(
              backgroundColor: Color(0xFF1E1E1E),
              foregroundColor: Colors.white,
              elevation: 0,
            ),
            cardColor: const Color(0xFF1E1E1E),
            dividerColor: Colors.white12,
          ),

          // tema yang sedang aktif
          themeMode: currentTheme,

          home: const OnboardingPage(),
        );
      },
    );
  }
}




