import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hotelapps/ui/authentication/forgotpassword.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:hotelapps/ui/authentication/signup.dart';
import 'package:hotelapps/services/auth_service.dart';
import 'package:hotelapps/ui/screens/home.dart';
import 'package:hotelapps/ui/ui_admin/admindashboard.dart';
import 'package:hotelapps/ui/ui_partner/partnerdashboard.dart';

class LoginPage extends StatefulWidget{
  const LoginPage({super.key});
  @override
  State<LoginPage> createState()=>_LoginPageState();
}

class _LoginPageState extends State<LoginPage>{
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  late final StreamSubscription<AuthState> authSubscription;

  bool _obscurePassword = true; //menyembunyikan password
  bool _isNavigating = false;

  @override
  void initState() {
    super.initState();
    authSubscription = Supabase.instance.client.auth.onAuthStateChange.listen((data) {
      if (data.event == AuthChangeEvent.signedIn &&
          mounted &&
          !_isNavigating) {
        _isNavigating = true;
        _navigateBasedOnRole();
        // Navigator.push(context, MaterialPageRoute(builder: (context) => const HomePage()));
      }
    });
  }

  //fungsi untuk mengecek role akun
  Future<void> _navigateBasedOnRole() async {
    try {
      final supabase = Supabase.instance.client;
      final user = supabase.auth.currentUser;

      if (user == null) {
        _isNavigating = false;
        return;
      }

      final profile = await supabase
          .from('profiles')
          .select('role')
          .eq('id', user.id)
          .maybeSingle();

      if (!mounted) return;

      if (profile == null) {
        _isNavigating = false;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Data profil pengguna tidak ditemukan'),
          ),
        );
        return;
      }

      final role = profile['role'];

      if (role == 'admin') {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const AdminDashboard(),
          ),
              (route) => false,
        );
      } else if (role == 'partner') {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const PartnerDashboard(),
          ),
              (route) => false,
        );
      } else if (role == 'customer') {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const HomePage(),
          ),
              (route) => false,
        );
      } else {
        _isNavigating = false;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Role akun tidak dikenali'),
          ),
        );
      }
    } catch (e) {
      _isNavigating = false;

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal memeriksa role akun: $e'),
        ),
      );
    }
  }
  
  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(left: 20, top: 70, right: 20, bottom: 20),
            child: Column(
              children: [
                Image.asset(
                  'assets/images/logo.png',
                  width: 100,
                  height: 100,
                ),
                SizedBox(height: 10),
                Text('Welcome Back!',style: TextStyle(
                    fontSize: 25,
                    color: Colors.black,
                    decoration: TextDecoration.none
                ),
                    textAlign: TextAlign.center
                ),
                SizedBox(height: 10),
                Text('Log in to your Ubulla account and discover a comfortable stay for your next journey.', style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                    decoration: TextDecoration.none
                ),
                    textAlign: TextAlign.center
                ),
                SizedBox(height: 40),
                //form loginnn
                //input email
                TextFormField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                      labelText: 'Enter your email address',
                      prefixIcon: Icon(Icons.email_outlined),
                      floatingLabelBehavior: FloatingLabelBehavior.auto, //supaya pas pencet field inputnya, textnya jd naik ke atas kiri
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    //kondisi klo fieldnya ditekan, bordernya tetap warna hitam
                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12),borderSide: BorderSide(color: Colors.black)),
                    floatingLabelStyle: TextStyle(color: Colors.black) //warna labelTextnya saat floating biar tetap hitam
                  ),
                ),
                SizedBox(height: 20),
                //input password
                TextFormField(
                  controller: passwordController,
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                      labelText: 'Enter your Password',
                      prefixIcon: Icon(Icons.lock_outline),
                      floatingLabelBehavior: FloatingLabelBehavior.auto, //supaya pas pencet field inputnya, textnya jd naik ke atas kiri
                      suffixIcon: IconButton(
                          onPressed: (){
                            setState(() {
                              _obscurePassword=!_obscurePassword;
                            });
                          },
                          icon: Icon(_obscurePassword ? Icons.visibility_off: Icons.visibility)
                      ),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      //kondisi klo fieldnya ditekan, bordernya tetap warna hitam
                      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12),borderSide: BorderSide(color: Colors.black)),
                      floatingLabelStyle: TextStyle(color: Colors.black) //warna labelTextnya saat floating biar tetap hitam
                  ),
                ),
                SizedBox(height: 20),
                //tombol submit (Login)
                ElevatedButton(
                    onPressed: () async {
                      if (emailController.text.trim().isEmpty ||
                          passwordController.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Email dan password wajib diisi')),
                        );
                        return;
                      }

                      try {
                        await AuthService().loginWithEmail(
                          email: emailController.text.trim(),
                          password: passwordController.text,
                        );

                        // Navigasi ke HomePage akan dilakukan oleh authSubscription.
                      } on AuthException catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(e.message)),
                        );
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Terjadi kesalahan saat login')),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        minimumSize: Size(double.infinity, 45) //lebar,tinggi
                    ),
                    child: Text('Log In',style: TextStyle(fontSize: 15),)
                ),
                SizedBox(height: 20),
                //DIVIDER untuk OR
                Row(
                  children: [
                    Expanded(child: Divider()),
                    Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15),
                      child: Text('OR', style: TextStyle(color: Colors.grey)),
                    ),
                    Expanded(child: Divider())
                  ],
                ),
                SizedBox(height: 20),
                //pilihan login menggunakan akun Google
                ElevatedButton(
                    onPressed: () async{
                      //Google authentication
                      await AuthService().loginWithGoogle();
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.infinity, 50),
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide(color: Colors.black)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/google.png',
                          width: 22,
                          height: 22,
                        ),
                        SizedBox(width: 12),
                        Text('Continue with Google', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),)
                      ],
                    )
                ),
                SizedBox(height: 25),
                //LUPA PASSWORD (reset password)
                TextButton(
                    onPressed: (){
                      //arahin ke halaman forgot password
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const ForgotPasswordPage()));
                    },
                    //supaya ga ada efek2 di pas mau mencet tulisannya
                    style: TextButton.styleFrom(overlayColor: Colors.transparent),
                    child: Text('Forgot Password?',style: TextStyle(color: Colors.black, fontSize: 14, decoration: TextDecoration.underline,))
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Don't have any accound?", style: TextStyle(color: Colors.grey, fontSize: 14,)),
                    SizedBox(width: 3,),
                    TextButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const SignupPage()));
                      },
                      //supaya ga ada efek2 di pas mau mencet tulisannya
                      style: TextButton.styleFrom(overlayColor: Colors.transparent),
                      child: Text('Sign Up', style: TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}