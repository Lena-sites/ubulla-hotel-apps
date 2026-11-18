import 'package:supabase_flutter/supabase_flutter.dart';

//Memanggil Google OAuth melalui Supabase
//Membuka proses login Google
//Mengarahkan pengguna kembali ke Flutter Web setelah autentikasi (sudah tersetting juga di Supabasenya)
class AuthService {
  final supabase = Supabase.instance.client;

  Future<void> signInWithGoogle() async {
    await supabase.auth.signInWithOAuth(
      OAuthProvider.google,
      redirectTo: 'http://localhost:5000',
    );
  }

  Future<AuthResponse> signInWithEmail({
    required String email,
    required String password,
  }) async {
    return await supabase.auth.signInWithPassword(
      email: email,
      password: password
    );
  }

  //signup manual
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