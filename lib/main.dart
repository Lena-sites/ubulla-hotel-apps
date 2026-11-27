import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hotelapps/ui/authentication/resetpassword.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:hotelapps/ui/screens/onboarding.dart';
import 'package:hotelapps/services/auth_state.dart';
import 'package:hotelapps/services/theme_controller.dart';
import 'package:hotelapps/ui/screens/home.dart';
import 'package:hotelapps/ui/ui_admin/admindashboard.dart';
import 'package:hotelapps/ui/ui_partner/partnerdashboard.dart';


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

  //validasi session saat approval admin
  RealtimeChannel? _profileChannel;
  StreamSubscription<AuthState>? _authSubscription;

  //Simpan Future agar tidak dipanggil berulang
  late Future<Widget> _initialPageFuture;

  //fungsi untuk menentukan halaman awal.
  Future<Widget> _getInitialPage() async {
    final supabase = Supabase.instance.client;
    final user = supabase.auth.currentUser;

    if (user == null) {
      return const OnboardingPage();
    }

    final profile = await supabase
        .from('profiles')
        .select('role')
        .eq('id', user.id)
        .maybeSingle();

    final role = profile?['role'];

    if (role == 'admin') {
      return const AdminDashboard();
    } else if (role == 'partner') {
      return const PartnerDashboard();
    } else if (role == 'customer') {
      return const HomePage();
    }

    return const OnboardingPage();
  }

  void _listenToRoleChanges() {
    final supabase = Supabase.instance.client;
    final user = supabase.auth.currentUser;

    if (user == null) return;

    _profileChannel = supabase
        .channel('profile-role-${user.id}')
        .onPostgresChanges(
      event: PostgresChangeEvent.update,
      schema: 'public',
      table: 'profiles',
      filter: PostgresChangeFilter(
        type: PostgresChangeFilterType.eq,
        column: 'id',
        value: user.id,
      ),
      callback: (payload) async {
        if (payload.newRecord['role'] == 'partner' && mounted) {
          await supabase.auth.signOut();

          if (!mounted) return;

          navigatorKey.currentState?.pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => const OnboardingPage(),
            ),
                (route) => false,
          );
        }
      },
    ).subscribe();
  }

  @override
  void initState(){
    super.initState();
    _initialPageFuture = _getInitialPage();
    _authSubscription = Supabase.instance.client.auth.onAuthStateChange.listen((data) {
      if (data.event == AuthChangeEvent.signedIn) {
        _listenToRoleChanges();
      }

      if (data.event == AuthChangeEvent.signedOut) {
        if (_profileChannel != null) {
          Supabase.instance.client.removeChannel(_profileChannel!);
          _profileChannel = null;
        }
      }

      if (data.event == AuthChangeEvent.passwordRecovery) {
        isPasswordRecovery = true;
        _goToReset();
      }
    });

    // Pasang listener untuk sesi yang sudah login saat aplikasi dibuka
    _listenToRoleChanges();
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

  //untuk membersihkan subscription Auth dan Realtime ketika MyApp sudah tidak digunakan
  @override
  void dispose() {
    _authSubscription?.cancel();

    if (_profileChannel != null) {
      Supabase.instance.client.removeChannel(_profileChannel!);
      _profileChannel = null;
    }

    super.dispose();
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

          //Kalau sesi login tersimpan dan role admin → AdminDashboard
          //Kalau role user → HomePage
          //Kalau belum login → OnboardingPage
          //Selama pengecekan berlangsung → loading indicator
          home: FutureBuilder<Widget>(
            future: _initialPageFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Scaffold(
                  body: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }

              if (snapshot.hasError) {
                return const OnboardingPage();
              }

              return snapshot.data ?? const OnboardingPage();
            },
          ),
        );
      },
    );
  }
}




