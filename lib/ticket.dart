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
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center, // Bikin konten utama rata tengah
                children: [
                  const SizedBox(height: 10),
                  const Text(
                    'CHECK-IN TICKET',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Divider(color: Colors.grey[300], thickness: 1, height: 30),
                  Image.asset(
                    'assets/images/qr.jpg',
                    width: 250, // Disesuaikan agar lebih aman di layar kecil
                    height: 250,
                  ),
                  Divider(color: Colors.grey[300], thickness: 1, height: 30),
                  const SizedBox(height: 10),

                  // Informasi Tiket
                  Column(
                    children: [
                      // baris 1
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center, // Ubah ke .start jika ingin teks rata kiri di dalam kolomnya
                              children: [
                                const Text('Name', style: TextStyle(color: Colors.grey, fontSize: 12)),
                                const SizedBox(height: 4),
                                const Text('Lena', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600), textAlign: TextAlign.center),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Text('Phone Number', style: TextStyle(color: Colors.grey, fontSize: 12)),
                                const SizedBox(height: 4),
                                const Text('+62xxxxxxxxxxx', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600), textAlign: TextAlign.center),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 25),
                      // baris 2
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Text('Check in', style: TextStyle(color: Colors.grey, fontSize: 12)),
                                const SizedBox(height: 4),
                                const Text('Oct 07, 2026', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600), textAlign: TextAlign.center),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Text('Check out', style: TextStyle(color: Colors.grey, fontSize: 12)),
                                const SizedBox(height: 4),
                                const Text('Oct 08, 2026', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600), textAlign: TextAlign.center),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 25),
                      // baris 3
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Text('Hotel', style: TextStyle(color: Colors.grey, fontSize: 12)),
                                const SizedBox(height: 4),
                                Text(widget.hotel.name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600), textAlign: TextAlign.center),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Text('Guest', style: TextStyle(color: Colors.grey, fontSize: 12)),
                                const SizedBox(height: 4),
                                Text('${widget.guest}', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600), textAlign: TextAlign.center),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                      child: const Text(
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
          ),
        )
    );
  }
}