import 'package:supabase_flutter/supabase_flutter.dart';

//all proses authentication diatur ama backend dari supabase
//Memanggil Google OAuth melalui Supabase
//Membuka proses login Google
//Mengarahkan pengguna kembali ke Flutter Web setelah autentikasi (sudah tersetting juga di Supabasenya)
class AuthService {
  final supabase = Supabase.instance.client;

  //login dengan google
  Future<void> loginWithGoogle() async {
    await supabase.auth.signInWithOAuth(
      OAuthProvider.google,
      redirectTo: 'http://localhost:5000',
    );
  }

  //login dengan email (manual)
  //return value karna hasil login digunakan Flutter untuk melakukan pemeriksaan kondisi sebelum berpindah halaman
  Future<AuthResponse> loginWithEmail({
    required String email,
    required String password,
  }) async {
    return await supabase.auth.signInWithPassword(
      email: email,
      password: password
    );
  }

  //signup dengan google
  Future<void> signUpWithGoogle() async {
    await supabase.auth.signInWithOAuth(
      OAuthProvider.google,
      redirectTo: 'http://localhost:5000',
    );
  }

  //signup manual (return value karna datanya mau dipake)
  Future<AuthResponse> signUp({
    required String email,
    required String username,
    required String password,
  }) async {
    return await supabase.auth.signUp(
      //email dan pass dikelola supabasenya
      email: email,
      password: password,
      data: {
        'username': username, //Username tersimpan di metadata akun (simpan di dbnya)
      }
    );
  }
}