import 'package:flutter/material.dart';
import 'package:hotelapps/class_list.dart';
import 'package:hotelapps/ui/screens/payment.dart';
import 'package:hotelapps/models/hotels.dart';
import 'package:hotelapps/models/hotelrooms.dart';

class CustomPage extends StatefulWidget {
  //mengambil data hotel yang telah dipilih sebelumnya di search page
  final Hotels hotel;
  final HotelRooms selectedRoom;

  const CustomPage({
    super.key,
    required this.hotel,
    required this.selectedRoom,
  });

  @override
  State<CustomPage> createState() => _CustomPage();
}

class _CustomPage extends State<CustomPage> {
  //variabel
  int guest=1;
  int room=1;
  int day=1;
  DateTime? checkInDate;
  DateTime? checkOutDate;

  int get totalPrice => widget.selectedRoom.pricePerNight * day * room;

  //fungsi pilih tanggal Check-in
  Future<void> pilihCheckIn() async {
    final now = DateTime.now();

    //Membuka kalender bawaan Flutter
    final picked = await showDatePicker(
      context: context,
      initialDate: checkInDate ?? now, //Tidak mengizinkan pengguna memilih tanggal yang sudah lewat.
      firstDate: DateTime(now.year, now.month, now.day),
      lastDate: DateTime(now.year + 2),
    );

    //Mengosongkan tanggal check-out jika tanggalnya tidak lagi valid setelah check-in diubah
    if (picked != null) {
      setState(() {
        checkInDate = picked;

        if (checkOutDate != null &&
            !checkOutDate!.isAfter(picked)) {
          checkOutDate = null;
        }
      });
    }
  }

  //pilih tanggal Check-out
  Future<void> pilihCheckOut() async {

    //Check-out hanya bisa dipilih setelah Check-in
    if (checkInDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Pilih tanggal check-in terlebih dahulu'),
        ),
      );
      return;
    }

    //Tanggal check-out harus minimal satu hari setelah check-in
    final picked = await showDatePicker(
      context: context,
      initialDate: checkOutDate ?? checkInDate!.add(Duration(days: 1)),
      firstDate: checkInDate!.add(Duration(days: 1)),
      lastDate: DateTime.now().add(Duration(days: 365 * 2)),
    );

    //day otomatis menghitung jumlah malam
    if (picked != null) {
      setState(() {
        checkOutDate = picked;
        day = checkOutDate!.difference(checkInDate!).inDays;
      });
    }
  }

  //8000 jadi 8.000 ada titiknya
  String formatRupiah(int harga) {
    return harga.toString().replaceAllMapped(
      RegExp(r'\B(?=(\d{3})+(?!\d))'),
          (match) => '.',
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey,
        title: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('UBULLA', style: TextStyle(fontFamily: 'Cormorant_Garamond', fontSize: 18,)),
                  Text('Hotel and Resort', style: TextStyle(fontFamily: 'Cormorant_Garamond', fontSize: 9,)),
                ],
              ),
            ),
            SizedBox(width: 5),
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                'assets/images/logo.png',
                width: 40,
                height: 40,
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('Select Date', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold,)),
                SizedBox(height: 20),
                // CALENDAR
                SizedBox(height: 20,),
                Row(
                  children: [
                    // CHECK IN
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Check in', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,),),
                          SizedBox(height: 10),
                          GestureDetector(
                            onTap: pilihCheckIn,
                            child: Container(
                              height: 50,
                              padding: EdgeInsets.symmetric(horizontal: 15),
                              decoration: BoxDecoration(
                                color: Colors.grey[100],
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                children: [
                                  Text(
                                    checkInDate == null
                                        ? 'Select date'
                                        : '${checkInDate!.day.toString().padLeft(2, '0')}/'
                                        '${checkInDate!.month.toString().padLeft(2, '0')}/'
                                        '${checkInDate!.year}',
                                  ),
                                  Spacer(),
                                  Icon(Icons.calendar_month_outlined, size: 20),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 20),
                    // panah tengah
                    Padding(
                      padding: EdgeInsets.only(top: 30),
                      child: Icon(Icons.arrow_right_alt, size: 25),
                    ),
                    SizedBox(width: 20),
                    // CHECK OUT
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Check out', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,),),
                          SizedBox(height: 10),
                          GestureDetector(
                            onTap: pilihCheckOut,
                            child: Container(
                              height: 50,
                              padding: EdgeInsets.symmetric(horizontal: 15),
                              decoration: BoxDecoration(
                                color: Colors.grey[100],
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                children: [
                                  Text(
                                    checkOutDate == null
                                        ? 'Select date'
                                        : '${checkOutDate!.day.toString().padLeft(2, '0')}/'
                                        '${checkOutDate!.month.toString().padLeft(2, '0')}/'
                                        '${checkOutDate!.year}',
                                  ),
                                  Spacer(),
                                  Icon(Icons.calendar_month_outlined, size: 20),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20,),
                //masukin jumlah GUEST
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Guest', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,)),
                    SizedBox(height: 10),
                    Container(
                      width: double.infinity,
                      height: 70,
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.grey[200]!,),
                      ),
                      child:Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // TOMBOL MINUS
                          GestureDetector(
                            onTap: () {
                              if (guest > 1) {
                                setState(() {
                                  guest--;
                                });
                              }
                            },
                            child: Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                color: Colors.greenAccent[100],
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Center(
                                child: Text(
                                  '−',
                                  style: TextStyle(
                                    color: Colors.green,
                                    fontSize: 24,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 40),
                          // JUMLAH GUEST
                          Text(
                            '$guest',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: 40),
                          // TOMBOL PLUS
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                guest++;
                              });
                            },
                            child: Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                color: Colors.greenAccent[100],
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Center(
                                child: Text(
                                  '+',
                                  style: TextStyle(
                                    color: Colors.green,
                                    fontSize: 24,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20,),
                //masukin jumlah kamar/room yang dipesann
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Room', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,)),
                    SizedBox(height: 10),
                    Container(
                      width: double.infinity,
                      height: 70,
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.grey[200]!,),
                      ),
                      child:Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // TOMBOL MINUS
                          GestureDetector(
                            onTap: () {
                              if (room > 1) {
                                setState(() {
                                  room--;
                                });
                              }
                            },
                            child: Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                color: Colors.greenAccent[100],
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Center(
                                child: Text(
                                  '−',
                                  style: TextStyle(
                                    color: Colors.green,
                                    fontSize: 24,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 40),
                          // JUMLAH ROOM
                          Text(
                            '$room',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: 40),
                          // TOMBOL PLUS
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                room++;
                              });
                            },
                            child: Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                color: Colors.greenAccent[100],
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Center(
                                child: Text(
                                  '+',
                                  style: TextStyle(
                                    color: Colors.green,
                                    fontSize: 24,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20,),
                Text('Rp ${formatRupiah(totalPrice)}', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),textAlign: TextAlign.center,),
                ElevatedButton(
                    onPressed: (){
                      // Cek apakah tanggal check-in dan check-out sudah dipilih
                      if (checkInDate == null || checkOutDate == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Please select check-in and check-out dates first.'),
                            backgroundColor: Colors.red,
                          ),
                        );
                        return;
                      }
                      Navigator.push(context, MaterialPageRoute(builder: (context) => PaymentPage(hotel:widget.hotel, guest: guest, room: room, roomId: widget.selectedRoom.id, totalPrice: totalPrice, checkInDate: checkInDate!, checkOutDate: checkOutDate!)) //KIRIM VARIABEL ke page Payment
                      );
                    },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green,   minimumSize: Size(double.infinity, 50)),
                    child: Text('Continue',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}