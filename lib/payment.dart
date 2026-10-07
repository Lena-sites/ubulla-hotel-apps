import 'package:flutter/material.dart';
import 'package:hotelapps/class_list.dart';
import 'package:hotelapps/class_list.dart';
import 'package:hotelapps/confirmpayment.dart';

class PaymentPage extends StatefulWidget {
  final HotelList hotel;
  final int guest;
  final int room;
  final int totalPrice;

  const PaymentPage({
    super.key,
    required this.hotel,
    required this.guest,
    required this.room,
    required this.totalPrice,
  });

  @override
  State<PaymentPage> createState() => _PaymentPage();
}

class _PaymentPage extends State<PaymentPage> {
  int selected=0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.grey,
        title: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('UBULLA',
                    style: TextStyle(fontFamily: 'Cormorant_Garamond', fontSize: 18),
                  ),
                  Text('Hotel and Resort',
                    style: TextStyle(fontFamily: 'Cormorant_Garamond', fontSize: 9),
                  )
                ],
              ),
            ),
            SizedBox(width: 5,),
            ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  'assets/images/logo.png',
                  width: 40,
                  height: 40,
                )
            ),
          ],
        ),
      ),
      body: SafeArea(
        // child: SingleChildScrollView(
          child:  Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                //tulisan payment methods dan add new card
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
                        Text(paymentMethod[0].method, style: TextStyle(fontWeight: FontWeight.bold)),
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
                        Image.asset('assets/images/cc.jpg', width: 28, height: 28),
                        SizedBox(width: 12),
                        Text(paymentMethod[1].method, style: TextStyle(fontWeight: FontWeight.bold)),
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
                        Image.asset('assets/images/bca.jpg', width: 28, height: 28),
                        SizedBox(width: 16),
                        Text(paymentMethod[2].method, style: TextStyle(fontWeight: FontWeight.bold)),
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
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ConfirmPage(
                          hotel: widget.hotel,
                          guest: widget.guest,
                          room: widget.room,
                          totalPrice: widget.totalPrice,
                          payMet: paymentMethod[selected].method,
                        ),
                      ),
                    );
                  },
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