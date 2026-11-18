import 'package:flutter/material.dart';
import 'package:hotelapps/ui/screens/login.dart';

class Onboarding2 extends StatefulWidget{
  const Onboarding2({super.key});
  @override
  State<Onboarding2> createState()=>_Onboarding2State();
}

class _Onboarding2State extends State<Onboarding2>{

  @override
  Widget build(BuildContext context){
    return Padding(
      padding: EdgeInsets.only(left: 20, top: 150, right: 20, bottom: 20),
      child: Column(
        // crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/fotoOnboarding2.png',
            width: 250,
            height: 250,
          ),
          SizedBox(height: 10,),
          Text('Welcome to Ubulla!',style: TextStyle(
              fontSize: 25,
              color: Colors.black,
              decoration: TextDecoration.none
            ),
            textAlign: TextAlign.center
          ),
          Text('Your next getaway is just a few taps away. Explore, choose, and book your perfect stay.',style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
              decoration: TextDecoration.none
            ),
            textAlign: TextAlign.center
          ),
          SizedBox(height: 30,),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              minimumSize: Size(double.infinity, 55) //lebar,tinggi
            ),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginPage()));
            },
            child: Text('Get Started', style: TextStyle(fontSize: 20),),
          )
        ],
      ),
    );
  }
}