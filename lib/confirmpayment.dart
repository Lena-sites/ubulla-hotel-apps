import 'package:flutter/material.dart';
import 'package:hotelapps/class_list.dart';
import 'package:hotelapps/main.dart';
import 'package:hotelapps/ticket.dart';

class ConfirmPage extends StatefulWidget {
  //hal baru di sini
  final HotelList hotel;
  final int guest;
  final int room;
  final int totalPrice;
  final String payMet;

  const ConfirmPage({super.key,
    required this.hotel,
    required this.guest,
    required this.room,
    required this.totalPrice,
    required this.payMet,
  });

  @override
  State<ConfirmPage> createState() => _ConfirmPage();
}


class _ConfirmPage extends State<ConfirmPage> {

  //perhitungan pajak dan juga total finalnya
  int get taxesFees => (widget.totalPrice * 0.1).round();
  int get finalPrice => widget.totalPrice + taxesFees;

  @override
  Widget build(BuildContext context){
    // mengambil ukuran layar
    final screenWidth = MediaQuery.of(context).size.width;
    //jika lebar >600 dianggap layarnya lebar/besar
    final isLargeScreen = screenWidth > 600;

    return Scaffold(
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
          child: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(20),
              color: Colors.grey[100],
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Booking Details', style: TextStyle(fontWeight: FontWeight.bold),),
                  SizedBox(height: 10,),
                  Container(
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.asset(
                              'assets/images/hotel8.jpg', //dummy-in aja
                              width: 80,
                              height: 80,
                              fit: BoxFit.cover
                          ),
                        ),
                        SizedBox(width: 10,),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(widget.hotel.name,
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                              ),
                              Text(widget.hotel.location, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10),),
                              Row(
                                children: [
                                  Text('Rp ${widget.hotel.price}', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),),
                                  Text(' / night', style: TextStyle(fontSize: 12),),
                                ],
                              )
                            ],
                          ),
                        ),
                        //pengkondisian untuk posisi keterangan harga sama tanda mark nya
                        LayoutBuilder(
                            builder: (context, constraint){
                              return Flex(
                                direction: isLargeScreen? Axis.horizontal: Axis.vertical,
                                crossAxisAlignment: isLargeScreen? CrossAxisAlignment.center: CrossAxisAlignment.end,
                                mainAxisAlignment: isLargeScreen? MainAxisAlignment.start: MainAxisAlignment.center,
                                children: [
                                  Row(
                                    children: [
                                      Icon(Icons.star, color: Colors.yellowAccent,size: 18,),
                                      SizedBox(width: 3,),
                                      Text('4.8'),
                                    ],
                                  ),
                                  //ini buat geser si icon mark nya supaya aga jauh dari "/ night" saat layarnya >600
                                  SizedBox(
                                    width: isLargeScreen ? 20 : 0,
                                    height: isLargeScreen ? 0 : 5,
                                  ),
                                  Icon(Icons.bookmark_border_outlined)
                                ],
                              );
                            }
                        ),
                        SizedBox(width: 10,)
                      ],
                    ),
                  ),
                  SizedBox(height: 20,),
                  Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text('Check in'),
                            Spacer(),
                            Text('October 07, 2026', style: TextStyle(fontWeight: FontWeight.bold))
                          ],
                        ),
                        SizedBox(height: 5,),
                        Row(
                          children: [
                            Text('Check out'),
                            Spacer(),
                            Text('October 08, 2026', style: TextStyle(fontWeight: FontWeight.bold))
                          ],
                        ),
                        SizedBox(height: 5,),
                        Row(
                          children: [
                            Text('Guest(s)'),
                            Spacer(),
                            Text('${widget.guest}', style: TextStyle(fontWeight: FontWeight.bold))
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 30,),
                  Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text('Room(s)'),
                            Spacer(),
                            Text('${widget.room}', style: TextStyle(fontWeight: FontWeight.bold))
                          ],
                        ),
                        SizedBox(height: 5,),
                        Row(
                          children: [
                            Text('Taxes & Fees (10%)'),
                            Spacer(),
                            Text('Rp $taxesFees', style: TextStyle(fontWeight: FontWeight.bold))
                          ],
                        ),
                        SizedBox(height: 5,),
                        Divider(color: Colors.grey[300], thickness: 1,height: 30,),
                        SizedBox(height: 5,),
                        Row(
                          children: [
                            Text('Total',style: TextStyle(fontWeight: FontWeight.bold)),
                            Spacer(),
                            Text('Rp $finalPrice', style: TextStyle(fontWeight: FontWeight.bold))
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 30,),
                  Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          if(widget.payMet=='Paypal')
                            Icon(Icons.paypal),
                          if(widget.payMet=='Credit Card')
                            Image.asset('assets/images/cc.jpg', width: 50, height: 50),
                          if(widget.payMet=='BCA M-Banking')
                            Image.asset('assets/images/bca.jpg', width: 50, height: 50),
                          SizedBox(width: 10),
                          Text(widget.payMet, style: TextStyle(fontWeight: FontWeight.bold),)
                        ],
                      )
                  ),
                  SizedBox(height: 20,),
                  ElevatedButton(
                    onPressed: (){
                      showPaymentSuccessDialog();
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.green, minimumSize: Size(double.infinity, 50)),
                    child: Text('Confirm Payment',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  )
                ],
              ),
            ),
          )
      ),
    );
  }

  //BARU NIHhhhhhhhhhhhhhhhhhhhhh
  void showPaymentSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false, // tidak bisa ditutup dengan tap di luar
      builder: (dialogContext) {
        return Dialog(
          backgroundColor: Colors.white,
          insetPadding: EdgeInsets.symmetric(horizontal: 40),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min, // tinggi mengikuti isi
              children: [
                // ICON CENTANG
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle, color: Colors.green
                  ),
                  child: Center(
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(Icons.check, color: Color(0xFF10B981), size: 32),
                    ),
                  ),
                ),
                SizedBox(height: 25),

                // JUDUL
                Text(
                  'Payment Successfull!',
                  style: TextStyle(
                    color: Color(0xFF10B981),
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 12),

                // DESKRIPSI
                Text(
                  'Successfully made payment and hotel booking',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14),
                ),
                SizedBox(height: 25),

                // TOMBOL VIEW TICKET
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(dialogContext); // tutup popup
                      //KE HALAMAN TIKET NTR
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => TicketPage(hotel: widget.hotel, guest: widget.guest, room: widget.room, totalPrice: widget.totalPrice, payMet: widget.payMet)),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF10B981),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    child: Text(
                      'View Ticket',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                SizedBox(height: 10),

                // TOMBOL CANCEL
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(dialogContext); // tutup popup
                      //KE HALAMAN HOME PAGE NTR
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => HomePage()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFE8F7EF),
                      foregroundColor: Color(0xFF10B981),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    child: Text(
                      'Cancel',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}