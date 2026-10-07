import 'package:flutter/material.dart';
import 'package:hotelapps/class_list.dart';

class CustomPage extends StatefulWidget {
  // hal baru di sini
  final HotelList hotel;

  const CustomPage({
    super.key,
    required this.hotel,
  });

  @override
  State<CustomPage> createState() => _CustomPage();
}

class _CustomPage extends State<CustomPage> {
  //variabel
  int guest=1;
  int room=1;
  int day = 1; //set statis 1 hari aja

  int get totalPrice => widget.hotel.price * day * room;

  // Menyimpan tanggal yang dipilih
  int? selectedDate;

  // Function untuk membuat tanggal kalender
  Widget calendarDate(int date) {
    // Mengecek apakah tanggal sedang dipilih
    bool selected = selectedDate == date;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedDate = date;
        });
      },
      child: Container(
        margin: EdgeInsets.all(3),
        decoration: BoxDecoration(
          color: selected
              ? Colors.green
              : Colors.transparent,
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Text(
            '$date',
            style: TextStyle(
              color: selected
                  ? Colors.white
                  : Colors.black,

              fontWeight: selected
                  ? FontWeight.bold
                  : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // mengambil ukuran layar
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey,
        title: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('UBULLA', style: TextStyle(fontFamily: 'Cormorant_Garamond', fontSize: 18,),),
                  Text('Hotel and Resort', style: TextStyle(fontFamily: 'Cormorant_Garamond', fontSize: 9,),),
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
                Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.greenAccent[100],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      // BULAN
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Oktober 2026', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,),),
                          Row(
                            children: [
                              Icon(Icons.chevron_left, color: Colors.green),
                              Icon(Icons.chevron_right, color: Colors.green),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      // NAMA HARI
                      Row(
                        children: [
                          Expanded(
                            child: Center(
                              child: Text('Mo'),
                            ),
                          ),
                          Expanded(
                            child: Center(
                              child: Text('Tu'),
                            ),
                          ),
                          Expanded(
                            child: Center(
                              child: Text('We'),
                            ),
                          ),
                          Expanded(
                            child: Center(
                              child: Text('Th'),
                            ),
                          ),
                          Expanded(
                            child: Center(
                              child: Text('Fr'),
                            ),
                          ),
                          Expanded(
                            child: Center(
                              child: Text('Sa'),
                            ),
                          ),
                          Expanded(
                            child: Center(
                              child: Text('Su'),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      // TANGGAL
                      GridView.count(
                        crossAxisCount: 7,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        children: [
                          // MINGGU PERTAMA
                          // 1 Desember 2024 = Minggu
                          Container(),
                          Container(),
                          Container(),
                          Container(),
                          Container(),
                          Container(),

                          calendarDate(1),
                          // MINGGU KEDUA
                          calendarDate(2),
                          calendarDate(3),
                          calendarDate(4),
                          calendarDate(5),
                          calendarDate(6),
                          calendarDate(7),
                          calendarDate(8),
                          // MINGGU KETIGA
                          calendarDate(9),
                          calendarDate(10),
                          calendarDate(11),
                          calendarDate(12),
                          calendarDate(13),
                          calendarDate(14),
                          calendarDate(15),
                          // MINGGU KEEMPAT
                          calendarDate(16),
                          calendarDate(17),
                          calendarDate(18),
                          calendarDate(19),
                          calendarDate(20),
                          calendarDate(21),
                          calendarDate(22),
                          // MINGGU KELIMA
                          calendarDate(23),
                          calendarDate(24),
                          calendarDate(25),
                          calendarDate(26),
                          calendarDate(27),
                          calendarDate(28),
                          calendarDate(29),
                          // MINGGU KEENAM
                          calendarDate(30),
                          calendarDate(31),
                        ],
                      ),
                    ],
                  ),
                ),
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
                          Container(
                            height: 50,
                            padding: EdgeInsets.symmetric(horizontal: 15),
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                Text('Oct 07'),
                                Spacer(),
                                Icon(Icons.calendar_month_outlined, size: 20,),
                              ],
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
                          Container(
                            height: 50,
                            padding: EdgeInsets.symmetric(horizontal: 15),
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                Text('Oct 08'),
                                Spacer(),
                                Icon(Icons.calendar_month_outlined, size: 20),
                              ],
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
                              if (guest > 0) {
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
                              if (room > 0) {
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
                          // JUMLAH GUEST
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
                Text('Rp $totalPrice', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),textAlign: TextAlign.center,),
                ElevatedButton(
                    onPressed: (){},
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