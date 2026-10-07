import 'package:flutter/material.dart';
import 'package:hotelapps/class_list.dart';
import 'package:hotelapps/detail.dart';
import 'package:hotelapps/main.dart';
import 'package:hotelapps/profile.dart';
import 'package:hotelapps/search.dart';

class BookingPage extends StatefulWidget {
  const BookingPage({super.key});

  @override
  State<BookingPage> createState() => _BookingPage();
}

class _BookingPage extends State<BookingPage> {
  // variabel kondisi untuk tombol tab
  bool ongoing = true;
  bool completed = false;
  bool canceled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey,
        title: Row(
          children: [
            ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  'assets/images/logo.png',
                  width: 40,
                  height: 40,
                )
            ),
            SizedBox(width: 5,),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
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
            Spacer(),
            Icon(Icons.notifications_none_outlined),
            SizedBox(width: 2),
            Icon(Icons.bookmark_outline)
          ],
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          //container terluar (basenya)
          child: Container(
              width: double.infinity,
              color: Colors.grey[200],
              child: Column(
                children: [
                  //judul halaman
                  Container(
                    padding: EdgeInsets.all(20),
                    child: Row(
                      children: [
                        Text('My Booking',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        Spacer(),
                        Icon(Icons.search),
                      ],
                    ),
                  ),
                  //Row ini bisa scroll ke samping
                  SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          SizedBox(width: 20,),
                          //ONGOING
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                ongoing = !ongoing;
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: ongoing ? Color(0xFF10B981) : Colors.white, // Background hijau / putih
                              side: BorderSide(
                                color: Colors.green, // Warna border hijau untuk kedua kondisi
                                width: 1.5,
                              ),
                            ),
                            child: Text('Ongoing', style: TextStyle(
                              color: ongoing ? Colors.white: Colors.green,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                            ),
                          ),
                          SizedBox(width: 15,),
                          //COMPLETED
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                completed = !completed;
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: completed ? Color(0xFF10B981) : Colors.white, // Background hijau / putih
                              side: BorderSide(
                                color: Colors.green, // Warna border hijau untuk kedua kondisi
                                width: 1.5,
                              ),
                            ),
                            child: Text('Completed', style: TextStyle(
                              color: completed ? Colors.white: Colors.green,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                            ),
                          ),
                          SizedBox(width: 15,),
                          //CANCELED
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                canceled = !canceled;
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: canceled ? Color(0xFF10B981) : Colors.white, // Background hijau / putih
                              side: BorderSide(
                                color: Colors.green, // Warna border hijau untuk kedua kondisi
                                width: 1.5,
                              ),
                            ),
                            child: Text('Canceled', style: TextStyle(
                              color: canceled ? Colors.white: Colors.green,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                            ),
                          ),
                        ],
                      )
                  ),
                  SizedBox(height: 20,),
                  //kartu booking
                  Container(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      children: [
                        //booking ke1
                        Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10)
                          ),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.asset(
                                        'assets/images/hotel5.jpg',
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
                                        Text('Four Seasons Resort Bali at Jimbaran Bay',
                                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                                        ),
                                        Text('Jimbaran, Bali', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10),),
                                        SizedBox(height: 6,),
                                        //label paid
                                        Container(
                                          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                          decoration: BoxDecoration(
                                            color: Color(0xFFD1FAE5),
                                            borderRadius: BorderRadius.circular(4),
                                          ),
                                          child: Text('Paid', style: TextStyle(fontSize: 10, color: Colors.green),),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10,),
                              //garis pemisah
                              Container(height: 1, color: Colors.grey[300]),
                              SizedBox(height: 10,),
                              Row(
                                children: [
                                  Expanded(
                                    child: ElevatedButton(
                                      onPressed: () {},
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.white,
                                        side: BorderSide(
                                          color: Colors.green,
                                          width: 1.5,
                                        ),
                                      ),
                                      child: Text('Cancel Booking', style: TextStyle(
                                        color: Colors.green,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14,
                                      ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 10,),
                                  Expanded(
                                    child: ElevatedButton(
                                      onPressed: () {},
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Color(0xFF10B981),
                                        side: BorderSide(
                                          color: Colors.green,
                                          width: 1.5,
                                        ),
                                      ),
                                      child: Text('View Ticket', style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14,
                                      ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 20,),
                        //booking ke2
                        Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10)
                          ),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.asset(
                                        'assets/images/hotel6.jpg',
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
                                        Text('Amanjiwo',
                                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                                        ),
                                        Text('Desa Majaksingi, Borobudur', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10),),
                                        SizedBox(height: 6,),
                                        //label paid
                                        Container(
                                          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                          decoration: BoxDecoration(
                                            color: Color(0xFFD1FAE5),
                                            borderRadius: BorderRadius.circular(4),
                                          ),
                                          child: Text('Paid', style: TextStyle(fontSize: 10, color: Colors.green),),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10,),
                              //garis pemisah
                              Container(height: 1, color: Colors.grey[300]),
                              SizedBox(height: 10,),
                              Row(
                                children: [
                                  Expanded(
                                    child: ElevatedButton(
                                      onPressed: () {},
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.white,
                                        side: BorderSide(
                                          color: Colors.green,
                                          width: 1.5,
                                        ),
                                      ),
                                      child: Text('Cancel Booking', style: TextStyle(
                                        color: Colors.green,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14,
                                      ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 10,),
                                  Expanded(
                                    child: ElevatedButton(
                                      onPressed: () {},
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Color(0xFF10B981),
                                        side: BorderSide(
                                          color: Colors.green,
                                          width: 1.5,
                                        ),
                                      ),
                                      child: Text('View Ticket', style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14,
                                      ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 20,),
                        //booking ke3
                        Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10)
                          ),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.asset(
                                        'assets/images/hotel7.jpg',
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
                                        Text('The Ritz-Carlton Bali',
                                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                                        ),
                                        Text('Nusa Dua, Bali', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10),),
                                        SizedBox(height: 6,),
                                        //label paid
                                        Container(
                                          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                          decoration: BoxDecoration(
                                            color: Color(0xFFD1FAE5),
                                            borderRadius: BorderRadius.circular(4),
                                          ),
                                          child: Text('Paid', style: TextStyle(fontSize: 10, color: Colors.green),),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10,),
                              //garis pemisah
                              Container(height: 1, color: Colors.grey[300]),
                              SizedBox(height: 10,),
                              Row(
                                children: [
                                  Expanded(
                                    child: ElevatedButton(
                                      onPressed: () {},
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.white,
                                        side: BorderSide(
                                          color: Colors.green,
                                          width: 1.5,
                                        ),
                                      ),
                                      child: Text('Cancel Booking', style: TextStyle(
                                        color: Colors.green,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14,
                                      ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 10,),
                                  Expanded(
                                    child: ElevatedButton(
                                      onPressed: () {},
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Color(0xFF10B981),
                                        side: BorderSide(
                                          color: Colors.green,
                                          width: 1.5,
                                        ),
                                      ),
                                      child: Text('View Ticket', style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14,
                                      ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              )
          ),
        ),
      ),
      //tempat navigasi
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: Color(0xFF10B981),
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          if(index == 0){
            Navigator.push(context, MaterialPageRoute(builder: (context) => const HomePage()),
            );
          } else if (index == 1){
            Navigator.push(context, MaterialPageRoute(builder: (context) => const SearchPage()),
            );
          } else if (index == 2){
            Navigator.push(context, MaterialPageRoute(builder: (context) => const BookingPage()),
            );
          } else if (index == 3){
            Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfilePage()),
            );
          }
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(icon: Icon(Icons.receipt_long_outlined), label: 'Booking'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}