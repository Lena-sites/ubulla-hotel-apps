import 'package:flutter/material.dart';
import 'package:hotelapps/booking.dart';
import 'package:hotelapps/class_list.dart';

class TicketPage extends StatefulWidget {
  final HotelList hotel;
  final int guest;
  final int room;
  final int totalPrice;
  final String payMet;

  const TicketPage({super.key,
    required this.hotel,
    required this.guest,
    required this.room,
    required this.totalPrice,
    required this.payMet,
  });

  @override
  State<TicketPage> createState() => _TicketPage();
}

class _TicketPage extends State<TicketPage> {
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey,
        title: Row(
          children: [
            GestureDetector(
              onTap: (){
                bookingList.add(widget.hotel);
                Navigator.push(context, MaterialPageRoute(builder: (context) => const BookingPage()),
                );
              },
              child: Icon(Icons.arrow_back_rounded),
            ),
            Spacer(),
            Column(
              // crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text('UBULLA',
                  style: TextStyle(fontFamily: 'Cormorant_Garamond', fontSize: 18),
                ),
                Text('Hotel and Resort',
                  style: TextStyle(fontFamily: 'Cormorant_Garamond', fontSize: 9),
                )
              ],
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
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              color: Colors.white,
              padding: EdgeInsets.all(30),
              child: Column(
                children: [
                  Divider(color: Colors.grey[300], thickness: 1,height: 30,),
                  Image.asset('assets/images/qr.jpg', width: 300, height: 300,),
                  Divider(color: Colors.grey[300], thickness: 1,height: 30,),
                  SizedBox(height: 20),
                  Container(
                    padding: EdgeInsets.all(25),
                    child: Column(
                      children: [
                        // baris 1
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 160,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Name', style: TextStyle(color: Colors.grey)),
                                  SizedBox(height: 4),
                                  Text('Lena', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: 160,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Phone Number', style: TextStyle(color: Colors.grey)),
                                  SizedBox(height: 4),
                                  Text('+62 899 9999 9999', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 25),
                        //baris 2
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 160,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Check in', style: TextStyle(color: Colors.grey)),
                                  SizedBox(height: 4),
                                  Text('Oct 07, 2026', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: 160,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Check out', style: TextStyle(color: Colors.grey)),
                                  SizedBox(height: 4),
                                  Text('Oct 08, 2026', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 25),
                        // baris 3
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 160,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Hotel', style: TextStyle(color: Colors.grey)),
                                  SizedBox(height: 4),
                                  Text(widget.hotel.name, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: 160,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Guest', style: TextStyle(color: Colors.grey)),
                                  SizedBox(height: 4),
                                  Text('${widget.guest}', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                      child: Text(
                        'Download Ticket',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
      ),
    );
  }
}