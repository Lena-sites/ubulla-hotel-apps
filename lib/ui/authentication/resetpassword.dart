import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ResetPasswordPage extends StatefulWidget{
  const ResetPasswordPage({super.key});

  @override
  State<ResetPasswordPage> createState()=>_ResetPasswordPageState();
}

class  _ResetPasswordPageState extends State<ResetPasswordPage>{
  final passwordController = TextEditingController();

  bool _obscurePassword = true;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
            child : Padding(
              padding: EdgeInsets.only(left: 20, top: 70, right: 20, bottom: 20),
              child: Column(
                children: [
                  Image.asset(
                    'assets/images/logo.png',
                    width: 100,
                    height: 100,
                  ),
                  SizedBox(height: 10),
                  Text('Reset Password',style: TextStyle(
                      fontSize: 25,
                      color: Colors.black,
                      decoration: TextDecoration.none
                  ),
                      textAlign: TextAlign.center
                  ),
                  SizedBox(height: 10),
                  Text('Create a new password for your Ubulla account. Make sure it is secure and easy to remember.', style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                      decoration: TextDecoration.none
                  ),
                      textAlign: TextAlign.center
                  ),
                  SizedBox(height: 40),
                  //input password baruu
                  TextFormField(
                    controller: passwordController,
                    obscureText: _obscurePassword,
                    decoration: InputDecoration(
                        labelText: 'Enter your new password',
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
                  //tombol reset password
                  ElevatedButton(

                    onPressed: isLoading ? null : () async {
                      // Validasi password kosong
                      if (passwordController.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Please enter your new password'),
                          ),
                        );
                        return;
                      }

                      // Validasi panjang password
                      if (passwordController.text.length < 6) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Password must be at least 6 characters'),
                          ),
                        );
                        return;
                      }

                      setState(() {
                        isLoading = true;
                      });

                      try {
                        await Supabase.instance.client.auth.updateUser(
                          UserAttributes(
                            password: passwordController.text,
                          ),
                        );

                        if (!mounted) return;

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Password successfully updated!'),
                          ),
                        );

                        Navigator.pop(context);

                      } on AuthException catch (e) {
                        if (!mounted) return;

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(e.message)),
                        );

                      } catch (e) {
                        if (!mounted) return;

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('An error occurred. Please try again.'),
                          ),
                        );

                      } finally {
                        if (mounted) {
                          setState(() {
                            isLoading = false;
                          });
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      minimumSize: Size(double.infinity, 45),
                    ),
                    child: isLoading
                        ? SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                          )
                        : Text('Reset Password', style: TextStyle(fontSize: 15)
                    ),
                  ),
                  // Kembali ke login
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: TextButton.styleFrom(overlayColor: Colors.transparent,),
                    child: Text('Back to Log In', style: TextStyle(color: Colors.black, fontSize: 14, decoration: TextDecoration.underline),
                    ),
                  ),
                ],
              ),
            )
          )
      ),
    );
  }
}

