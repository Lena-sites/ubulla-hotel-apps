import 'package:flutter/material.dart';

void main() {
  runApp(const PaymentApp());
}

class PaymentApp extends StatelessWidget {
  const PaymentApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: PaymentPage(),
    );
  }
}

class PaymentPage extends StatefulWidget {
  const PaymentPage({super.key});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  // 0 = Paypal, 1 = Google Pay, 2 = Apple Pay
  int selected = 0;

  // metode pembayaran
  final List<String> methods = ['Paypal', 'Google Pay', 'Apple Pay'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.grey[200],
        elevation: 0,
        leading: Icon(Icons.arrow_back, color: Colors.black),
        title: Text(
          'Payment',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
        actions: [
          Image.asset('assets/images/scan.webp', width: 24, height: 24),
          SizedBox(width: 20),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              //tulisan ayment methods dan add new card
              Row(
                children: [
                  Text('Payment Methods', style: TextStyle(fontWeight: FontWeight.bold)),
                  Spacer(),
                  Text(
                    'Add New Card',
                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green),
                  ),
                ],
              ),
              SizedBox(height: 20),

              //paypal
              GestureDetector(
                onTap: () {
                  setState(() {
                    selected = 0;
                  });
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 22),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.paypal, color: Color(0xFF1E40AF), size: 28),
                      SizedBox(width: 16),
                      Text('Paypal', style: TextStyle(fontWeight: FontWeight.bold)),
                      Spacer(),
                      // radio buatan sendiri, hijau kalo kepilih
                      Icon(
                        selected == 0 ? Icons.radio_button_checked : Icons.radio_button_unchecked,
                        color: Color(0xFF10B981),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 15),

              //google pay
              GestureDetector(
                onTap: () {
                  setState(() {
                    selected = 1;
                  });
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 22),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Row(
                    children: [
                      Image.asset('assets/images/google.webp', width: 28, height: 28),
                      SizedBox(width: 12),
                      Text('Google Pay', style: TextStyle(fontWeight: FontWeight.bold)),
                      Spacer(),
                      Icon(
                        selected == 1 ? Icons.radio_button_checked : Icons.radio_button_unchecked,
                        color: Color(0xFF10B981),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 15),

              //apple pay
              GestureDetector(
                onTap: () {
                  setState(() {
                    selected = 2;
                  });
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 22),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Row(
                    children: [
                      Image.asset('assets/images/apple.webp', width: 28, height: 28),
                      SizedBox(width: 16),
                      Text('Apple Pay', style: TextStyle(fontWeight: FontWeight.bold)),
                      Spacer(),
                      Icon(
                        selected == 2 ? Icons.radio_button_checked : Icons.radio_button_unchecked,
                        color: Color(0xFF10B981),
                      ),
                    ],
                  ),
                ),
              ),

              Spacer(),

              //tombol continue
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF10B981),
                  minimumSize: Size(double.infinity, 55),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Text(
                  'Continue',
                  style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}