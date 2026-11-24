import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:hotelapps/ui_customer/screens/booking.dart';
import 'package:hotelapps/models/hotels.dart';
import 'package:hotelapps/services/ticket_service.dart';

class TicketPage extends StatefulWidget {
  //mengambil data hotel yang telah dipilih sebelumnya
  final Hotels hotel;
  final int guest;
  final int room;
  final int totalPrice;
  final String payMet;
  final DateTime checkInDate;
  final DateTime checkOutDate;
  final int transactionId;

  const TicketPage({super.key,
    required this.hotel,
    required this.guest,
    required this.room,
    required this.totalPrice,
    required this.payMet,
    required this.checkInDate,
    required this.checkOutDate,
    required this.transactionId,
  });

  @override
  State<TicketPage> createState() => _TicketPage();
}

class _TicketPage extends State<TicketPage> {
  final TicketService ticketService = TicketService();

  @override
  Widget build(BuildContext context){
    //Ambil email user
    final userEmail = Supabase.instance.client.auth.currentUser!.email!;
    final username = Supabase.instance.client.auth.currentUser!.userMetadata!['username'];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey,
        title: Row(
          children: [
            //tombol untuk keluar (diarahkan ke booking page)
            GestureDetector(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => const BookingPage()),
                );
              },
              child: Icon(Icons.arrow_back_rounded),
            ),
            Spacer(),
            Column(
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
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center, // Bikin konten utama rata tengah
                children: [
                  SizedBox(height: 10),
                  Text(
                    'CHECK-IN TICKET',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Divider(color: Colors.grey[300], thickness: 1, height: 30),
                  //isi dari QR Code nya ini kode booking yaa
                  QrImageView(
                    data: widget.transactionId.toString(), //isi QR Code, yaitu ID transaksi
                    version: QrVersions.auto, //menentukan versi QR secara otomatis
                    size: 250,
                  ),
                  Divider(color: Colors.grey[300], thickness: 1, height: 30),
                  SizedBox(height: 10),
                  // Informasi Tiket
                  Column(
                    children: [
                      // baris 1
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text('Name', style: TextStyle(color: Colors.grey, fontSize: 12)),
                                SizedBox(height: 4),
                                Text(username, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600), textAlign: TextAlign.center),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text('Email', style: TextStyle(color: Colors.grey, fontSize: 12)),
                                SizedBox(height: 4),
                                Text(userEmail, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600), textAlign: TextAlign.center),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 25),
                      // baris 2
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text('Check in', style: TextStyle(color: Colors.grey, fontSize: 12)),
                                SizedBox(height: 4),
                                //memisahkan tanggal dan waktu pake spasi lalu ambil hanya yg di index 0 aja, yaitu tglnya doang
                                Text('${widget.checkInDate}'.split(' ')[0], style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600), textAlign: TextAlign.center),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text('Check out', style: TextStyle(color: Colors.grey, fontSize: 12)),
                                SizedBox(height: 4),
                                Text('${widget.checkOutDate}'.split(' ')[0], style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600), textAlign: TextAlign.center),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 25),
                      // baris 3
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text('Hotel', style: TextStyle(color: Colors.grey, fontSize: 12)),
                                SizedBox(height: 4),
                                Text(widget.hotel.name, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600), textAlign: TextAlign.center),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text('Guest', style: TextStyle(color: Colors.grey, fontSize: 12)),
                                SizedBox(height: 4),
                                Text('${widget.guest}', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600), textAlign: TextAlign.center),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () async {
                        await ticketService.downloadTicket(
                          transactionId: widget.transactionId,
                          username: username?.toString() ?? '',
                          email: userEmail,
                          hotelName: widget.hotel.name,
                          guest: widget.guest,
                          checkInDate: widget.checkInDate,
                          checkOutDate: widget.checkOutDate,
                        );
                      },
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
          ),
        )
    );
  }
}