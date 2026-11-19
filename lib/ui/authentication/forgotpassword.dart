import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';


class ForgotPasswordPage extends StatefulWidget{
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState()=>_ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage>{
  final emailController = TextEditingController();

  bool isLoading = false;

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
                Text('Forgot Password?',style: TextStyle(
                    fontSize: 25,
                    color: Colors.black,
                    decoration: TextDecoration.none
                ),
                    textAlign: TextAlign.center
                ),
                SizedBox(height: 10),
                Text('Don’t worry! Enter your email address and we’ll send you a link to reset your password.', style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                    decoration: TextDecoration.none
                ),
                    textAlign: TextAlign.center
                ),
                SizedBox(height: 40),

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
                //tombol untuk mengirimkan link reset password
                ElevatedButton(
                    onPressed: isLoading ? null: () async {
                      if (emailController.text.trim().isEmpty){
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Please fill your E-Mail'),
                          )
                        );
                        return;
                      }
                      setState(() {
                        isLoading = true;
                      });
                      try {
                        await Supabase.instance.client.auth.resetPasswordForEmail(
                          emailController.text.trim(),
                          redirectTo: 'http://localhost:5000',
                        );
                        if (!mounted) return;
                        
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('If the email is registered, a password reset link will be sent.'),
                          )
                        );
                      } on AuthException catch (e){
                        if(!mounted) return;

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(e.message),
                          )
                        );
                      }catch (e) {
                        if (!mounted) return;

                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('An error occurred. Please try again.'),
                            )
                        );
                      } finally{
                        if(mounted){
                          setState(() {
                            isLoading = false;
                          });
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        minimumSize: Size(double.infinity, 45) //lebar,tinggi
                    ),
                    child: isLoading
                        ? SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(color: Colors.white,strokeWidth: 2),
                          )
                        : Text('Send Reset Link', style: TextStyle(fontSize: 15))
                ),
                SizedBox(height: 20),
                //Kembali ke halaman login
                TextButton(
                    onPressed: (){
                      Navigator.pop(context);
                    },
                    style: TextButton.styleFrom(overlayColor: Colors.transparent),
                    child: Text('Back to Log In', style: TextStyle(color: Colors.black, fontSize: 14, decoration: TextDecoration.underline),)
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}