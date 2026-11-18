import 'package:flutter/material.dart';
import 'package:hotelapps/ui/screens/login.dart';

class SignupPage extends StatefulWidget{
  const SignupPage({super.key});
  @override
  State<SignupPage> createState()=>_SignupPageState();
}

class _SignupPageState extends State<SignupPage>{
  final emailController = TextEditingController();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  bool _obscurePassword = true; //menyembunyikan password

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
                Text('Create an Account!',style: TextStyle(
                    fontSize: 25,
                    color: Colors.black,
                    decoration: TextDecoration.none
                ),
                    textAlign: TextAlign.center
                ),
                SizedBox(height: 10),
                Text('Join Ubulla today and start exploring comfortable stays for your next getaway. Your perfect stay is just a few taps away.', style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                    decoration: TextDecoration.none
                ),
                    textAlign: TextAlign.center
                ),
                SizedBox(height: 40),
                //form Signup
                //input email
                TextFormField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                      labelText: 'E-Mail',
                      prefixIcon: Icon(Icons.email_outlined),
                      floatingLabelBehavior: FloatingLabelBehavior.auto, //supaya pas pencet field inputnya, textnya jd naik ke atas kiri
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      //kondisi klo fieldnya ditekan, bordernya tetap warna hitam
                      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12),borderSide: BorderSide(color: Colors.black)),
                      floatingLabelStyle: TextStyle(color: Colors.black) //warna labelTextnya saat floating biar tetap hitam
                  ),
                ),
                SizedBox(height: 20),
                //input username
                TextFormField(
                  controller: usernameController,
                  decoration: InputDecoration(
                      labelText: 'Username',
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
                      labelText: 'Create your Password',
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
                SizedBox(height: 25),
                //tombol submit (Login)
                ElevatedButton(
                    onPressed: (){
                      //SUBMITT
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        minimumSize: Size(double.infinity, 45) //lebar,tinggi
                    ),
                    child: Text('Log In',style: TextStyle(fontSize: 15),)
                ),
                SizedBox(height: 25),
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
                SizedBox(height: 25),
                //pilihan Signup menggunakan akun Google
                ElevatedButton(
                    onPressed: (){
                      //Google authentication, NTRRRR
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
                //tanya, already have acc supaya balik ke login lagi
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Already have an account?", style: TextStyle(color: Colors.grey, fontSize: 14,)),
                    SizedBox(width: 3,),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context, MaterialPageRoute(builder: (context) => const LoginPage()));
                      },
                      //supaya ga ada efek2 di pas mau mencet tulisannya
                      style: TextButton.styleFrom(overlayColor: Colors.transparent),
                      child: Text('Sign Up', style: TextStyle(
                        color: Color(0xFF10B981),
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