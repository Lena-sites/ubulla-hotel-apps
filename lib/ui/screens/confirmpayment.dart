import 'package:flutter/material.dart';
import 'package:hotelapps/ui/screens/home.dart';
import 'package:hotelapps/ui/screens/ticket.dart';
import 'package:hotelapps/models/hotels.dart';
import 'package:hotelapps/models/transaction.dart';
import 'package:hotelapps/services/transaction_service.dart';
import 'package:hotelapps/services/hotelroom_service.dart';

class ConfirmPage extends StatefulWidget {
  //mengambil data hotel yang telah dipilih sebelumnya
  final Hotels hotel;
  final int guest;
  final int room;
  final int roomId;
  final int totalPrice;
  final String payMet;
  final DateTime checkInDate;
  final DateTime checkOutDate;
  final String? cardholderName; //optional karna bca ama paypal ga ada namanya

  const ConfirmPage({super.key,
    required this.hotel,
    required this.guest,
    required this.room,
    required this.roomId,
    required this.totalPrice,
    required this.payMet,
    required this.checkInDate,
    required this.checkOutDate,
    this.cardholderName
  });

  @override
  State<ConfirmPage> createState() => _ConfirmPage();
}


class _ConfirmPage extends State<ConfirmPage> {
  // untuk proses penyimpanan transaksi ke dalam tabel transaksi di supabase
  final TransactionService transactionService = TransactionService();
  final HotelRoomService hotelRoomService = HotelRoomService(); //buat pengurangan jumlah kamarnya
  bool isLoading = false;

  int? transactionId;

  //perhitungan pajak dan juga total finalnya
  int get taxesFees => (widget.totalPrice * 0.1).round();
  int get finalPrice => widget.totalPrice + taxesFees;

  String formatDate(DateTime date) {
    const months = [
      'January', 'February', 'March', 'April',
      'May', 'June', 'July', 'August',
      'September', 'October', 'November', 'December'
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  //8000 jadi 8.000 ada titiknya
  String formatRupiah(int harga) {
    return harga.toString().replaceAllMapped(
      RegExp(r'\B(?=(\d{3})+(?!\d))'),
          (match) => '.',
    );
  }

  // function untuk menyimpan transaksi ke Supabase
  Future<void> confirmPayment() async {
    setState(() {
      isLoading = true;
    });

    try {
      final transaction = Transaction(
        hotelId: widget.hotel.id,
        roomId: widget.roomId,
        hotelName: widget.hotel.name,
        guest: widget.guest,
        room: widget.room,
        checkIn: widget.checkInDate,
        checkOut: widget.checkOutDate,
        totalPrice: finalPrice, //masukin yg uda final (uda include pajak)
        paymentMethod: widget.payMet,
      );

      //setelah transaksi berhasil disimpan, ID transaksi barunya akan tersimpan di variabel transactionId
      transactionId = await transactionService.addTransaction(transaction);

      // Mengurangi stok kamar setelah transaksi berhasil disimpan
      await hotelRoomService.reduceRoomStock(
        widget.roomId,
        widget.room,
      );

      if (!mounted) return;

      setState(() {
        isLoading = false;
      });

      showPaymentSuccessDialog();

    } catch (e) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal menyimpan transaksi: $e'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context){
    // mengambil ukuran layar
    final screenWidth = MediaQuery.of(context).size.width;
    //jika lebar >600 dianggap layarnya lebar/besar
    final isLargeScreen = screenWidth > 600;

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
                          child: Image.network(
                            widget.hotel.imageUrl,
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                width: 80,
                                height: 80,
                                color: Colors.grey.shade300,
                                child: Icon(
                                  Icons.image_not_supported,
                                  color: Colors.grey,
                                ),
                              );
                            },
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
                              Text('${widget.hotel.city}, ${widget.hotel.country}', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10),),
                              Row(
                                children: [
                                  Text('Rp ${formatRupiah(widget.totalPrice)}', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),),
                                  Text(' / night', style: TextStyle(fontSize: 12),),
                                ],
                              )
                            ],
                          ),
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
                            Text(formatDate(widget.checkInDate), style: TextStyle(fontWeight: FontWeight.bold))
                          ],
                        ),
                        SizedBox(height: 5,),
                        Row(
                          children: [
                            Text('Check out'),
                            Spacer(),
                            Text(formatDate(widget.checkOutDate), style: TextStyle(fontWeight: FontWeight.bold))
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
                            Text('Rp ${formatRupiah(taxesFees)}', style: TextStyle(fontWeight: FontWeight.bold))
                          ],
                        ),
                        SizedBox(height: 5,),
                        Divider(color: Colors.grey[300], thickness: 1,height: 30,),
                        SizedBox(height: 5,),
                        Row(
                          children: [
                            Text('Total',style: TextStyle(fontWeight: FontWeight.bold)),
                            Spacer(),
                            Text('Rp ${formatRupiah(finalPrice)}', style: TextStyle(fontWeight: FontWeight.bold))
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
                          if(widget.payMet.startsWith('Credit Card'))
                            Image.asset('assets/images/cc.jpg', width: 50, height: 50),
                            SizedBox(height: 4),
                            Text(
                              widget.cardholderName ?? '',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          if(widget.payMet=='BCA M-Banking')
                            Image.asset('assets/images/bca.jpg', width: 50, height: 50),
                          SizedBox(width: 10),
                          Text(widget.payMet, style: TextStyle(fontWeight: FontWeight.bold),)
                        ],
                      )
                  ),
                  SizedBox(height: 20,),
                  ElevatedButton(
                    onPressed: () {
                      if (!isLoading) {
                        confirmPayment();
                      }
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.green, minimumSize: Size(double.infinity, 50)),
                    child: isLoading ? CircularProgressIndicator(color: Colors.white) : Text('Confirm Payment', style: TextStyle(color: Colors.white, fontSize: 20),)
                  )
                ],
              ),
            ),
          )
      ),
    );
  }

  //function untuk menampilkan popup pembayaran berhasil
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
                Text('Payment Successfull!',
                  style: TextStyle(
                    color: Color(0xFF10B981),
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 12),
                // DESKRIPSI
                Text('Successfully made payment and hotel booking',
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
                      Navigator.pop(dialogContext);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TicketPage(
                            hotel: widget.hotel,
                            guest: widget.guest,
                            room: widget.room,
                            totalPrice: widget.totalPrice,
                            payMet: widget.payMet,
                            checkInDate: widget.checkInDate,
                            checkOutDate: widget.checkOutDate,
                            transactionId: transactionId!,
                          ),
                        ),
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
                      // bookingList.add(widget.hotel); //walaupun pengguna tekan cancel, bukan view ticket, data bookingnya tetap disimpan karna udah pembayaran
                      Navigator.pop(dialogContext); // tutup popup
                      //KE HALAMAN HOME PAGE klo dia tekan cancel
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