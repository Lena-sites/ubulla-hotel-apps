import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget{
  const HomePage({super.key});
  @override
  State<StatefulWidget> createState()=>_MyAppState();
}

class _MyAppState extends State<HomePage>{
  //variabel kondisi untuk gesture
  bool filter=false;

  List<Filtering>filtering=[
    Filtering(button:'Recommended'),
    Filtering(button: 'Popular'),
    Filtering(button: 'Trending'),
    Filtering(button: 'New'),
  ];

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
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                'assets/images/logo.png',
                width: 40,
                height: 40,
              )
            ),
            SizedBox(width: 5,),
            Column(
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
                //container untuk menampung "hello.." dan search bar"
                Container(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Welcome, Lena!',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10,),
                      Container(
                        width: double.infinity,
                        height: 45,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.grey[300],
                        ),
                        child: Row(
                          children: [
                            SizedBox(width: 10),
                            Icon(Icons.search_outlined, color: Colors.grey),
                            SizedBox(width: 5),
                            Text('Search', style: TextStyle(color: Colors.grey)),
                            Spacer(),
                            Icon(Icons.tune_outlined, color: Colors.grey),
                            SizedBox(width: 10)
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                //Row ini bisa scroll ke samping
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child:Row(
                    children: [
                      SizedBox(width: 20,),
                      //RECOMMENDED
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            filtering[0].filter = !filtering[0].filter;
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: filtering[0].filter ? Color(0xFF10B981) : Colors.white, // Background hijau / putih
                          side: BorderSide(
                            color: Colors.green, // Warna border hijau untuk kedua kondisi
                            width: 1.5,
                          ),
                        ),
                        child: Text('Recommended', style: TextStyle(
                            color: filtering[0].filter? Colors.white: Colors.green,
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      SizedBox(width: 15,),
                      //POPULAR
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            filtering[1].filter = !filtering[1].filter;
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: filtering[1].filter ? Color(0xFF10B981) : Colors.white, // Background hijau / putih
                          side: BorderSide(
                            color: Colors.green, // Warna border hijau untuk kedua kondisi
                            width: 1.5,
                          ),
                        ),
                        child: Text('Popular', style: TextStyle(
                            color: filtering[1].filter? Colors.white: Colors.green,
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      SizedBox(width: 15,),
                      //TRENDING
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            filtering[2].filter = !filtering[2].filter;
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: filtering[2].filter ? Color(0xFF10B981) : Colors.white, // Background hijau / putih
                          side: BorderSide(
                            color: Colors.green, // Warna border hijau untuk kedua kondisi
                            width: 1.5,
                          ),
                        ),
                        child: Text('Trending', style: TextStyle(
                            color: filtering[2].filter? Colors.white: Colors.green,
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      SizedBox(width: 15,),
                      //NEW
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            filtering[3].filter = !filtering[3].filter;
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: filtering[3].filter ? Color(0xFF10B981) : Colors.white, // Background hijau / putih
                          side: BorderSide(
                            color: Colors.green, // Warna border hijau untuk kedua kondisi
                            width: 1.5,
                          ),
                        ),
                        child: Text('New', style: TextStyle(
                            color: filtering[3].filter? Colors.white: Colors.green,
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                      )
                    ],
                  )
                ),
                SizedBox(height: 20,),
                //item2 hotel hasil dari filtering dan bisa di scroll ke samping
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      //hotel 1
                      SizedBox(width: 20,),
                      Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(30),
                            child: Image.asset(
                                'assets/images/hotel1.jpg',
                                width: 190,
                                height: 260,
                                fit: BoxFit.cover
                            ),
                          ),
                          //rating
                          Positioned(
                            top: 12,
                            right: 12,
                            child: Container(
                              width: 60,
                              height: 30,
                              decoration: BoxDecoration(
                                  color: Colors.green,
                                  borderRadius: BorderRadius.circular(20)
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.star, color: Colors.white, size: 13,),
                                  SizedBox(width: 5,),
                                  Text('4.8', style: TextStyle(fontSize: 12, color: Colors.white),)
                                ],
                              ),
                            )
                          ),
                          //info hotel
                          Positioned(
                              bottom: 12,
                              left: 12,
                              right: 12,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Emeralda De Hotel', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                                  Text('Paris, France', style: TextStyle(color: Colors.white, fontSize: 10)),
                                  Row(
                                    children: [
                                      Text('Rp 800.000', style: TextStyle(fontSize: 14, color: Colors.white, fontWeight: FontWeight.bold)),
                                      Text(' / per night', style: TextStyle(fontSize: 10, color: Colors.white)),
                                      Spacer(),
                                      Icon(Icons.bookmark_outline, color: Colors.white,)
                                    ],
                                  )
                                ],
                              )
                          ),
                        ],
                      ),
                      SizedBox(width: 20,),
                      //hotel 2
                      Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(30),
                            child: Image.asset(
                                'assets/images/hotel2.jpg',
                                width: 190,
                                height: 260,
                                fit: BoxFit.cover
                            ),
                          ),
                          //rating
                          Positioned(
                              top: 12,
                              right: 12,
                              child: Container(
                                width: 60,
                                height: 30,
                                decoration: BoxDecoration(
                                    color: Colors.green,
                                    borderRadius: BorderRadius.circular(20)
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.star, color: Colors.white, size: 13,),
                                    SizedBox(width: 5,),
                                    Text('4.8', style: TextStyle(fontSize: 12, color: Colors.white),)
                                  ],
                                ),
                              )
                          ),
                          //info hotel
                          Positioned(
                              bottom: 12,
                              left: 12,
                              right: 12,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Emeralda De Hotel', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                                  Text('Paris, France', style: TextStyle(color: Colors.white, fontSize: 10)),
                                  Row(
                                    children: [
                                      Text('Rp 800.000', style: TextStyle(fontSize: 14, color: Colors.white, fontWeight: FontWeight.bold)),
                                      Text(' / per night', style: TextStyle(fontSize: 10, color: Colors.white)),
                                      Spacer(),
                                      Icon(Icons.bookmark_outline, color: Colors.white,)
                                    ],
                                  )
                                ],
                              )
                          ),
                        ],
                      ),
                      SizedBox(width: 20,),
                      //hotel 3
                      Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(30),
                            child: Image.asset(
                                'assets/images/hotel3.jpg',
                                width: 190,
                                height: 260,
                                fit: BoxFit.cover
                            ),
                          ),
                          //rating
                          Positioned(
                              top: 12,
                              right: 12,
                              child: Container(
                                width: 60,
                                height: 30,
                                decoration: BoxDecoration(
                                    color: Colors.green,
                                    borderRadius: BorderRadius.circular(20)
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.star, color: Colors.white, size: 13,),
                                    SizedBox(width: 5,),
                                    Text('4.8', style: TextStyle(fontSize: 12, color: Colors.white),)
                                  ],
                                ),
                              )
                          ),
                          //info hotel
                          Positioned(
                              bottom: 12,
                              left: 12,
                              right: 12,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Emeralda De Hotel', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                                  Text('Paris, France', style: TextStyle(color: Colors.white, fontSize: 10)),
                                  Row(
                                    children: [
                                      Text('Rp 800.000', style: TextStyle(fontSize: 14, color: Colors.white, fontWeight: FontWeight.bold)),
                                      Text(' / per night', style: TextStyle(fontSize: 10, color: Colors.white)),
                                      Spacer(),
                                      Icon(Icons.bookmark_outline, color: Colors.white,)
                                    ],
                                  )
                                ],
                              )
                          ),
                        ],
                      ),
                      SizedBox(width: 20,),
                      //hotel 4
                      Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(30),
                            child: Image.asset(
                                'assets/images/hotel4.jpg',
                                width: 190,
                                height: 260,
                                fit: BoxFit.cover
                            ),
                          ),
                          //rating
                          Positioned(
                              top: 12,
                              right: 12,
                              child: Container(
                                width: 60,
                                height: 30,
                                decoration: BoxDecoration(
                                    color: Colors.green,
                                    borderRadius: BorderRadius.circular(20)
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.star, color: Colors.white, size: 13,),
                                    SizedBox(width: 5,),
                                    Text('4.8', style: TextStyle(fontSize: 12, color: Colors.white),)
                                  ],
                                ),
                              )
                          ),
                          //info hotel
                          Positioned(
                              bottom: 12,
                              left: 12,
                              right: 12,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Emeralda De Hotel', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                                  Text('Paris, France', style: TextStyle(color: Colors.white, fontSize: 10)),
                                  Row(
                                    children: [
                                      Text('Rp 800.000', style: TextStyle(fontSize: 14, color: Colors.white, fontWeight: FontWeight.bold)),
                                      Text(' / per night', style: TextStyle(fontSize: 10, color: Colors.white)),
                                      Spacer(),
                                      Icon(Icons.bookmark_outline, color: Colors.white,)
                                    ],
                                  )
                                ],
                              )
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20,),
                //tulisan Recenlty Booked dan see all
                Row(
                  children: [
                    SizedBox(width: 20,),
                    Text('Recently Booked', style: TextStyle(fontWeight: FontWeight.bold),),
                    Spacer(),
                    Text('See All', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green),),
                    SizedBox(width: 20,),
                  ],
                ),
                // SizedBox(height: 20,),
                //History Booking
                Container(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    children: [
                      //histori 1
                      Container(
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10)
                        ),
                        child: Row(
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
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('President Hotel', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),),
                                Text('Greek', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10),),
                                Row(
                                  children: [
                                    Text('Rp 450.000', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),),
                                    Text(' / night', style: TextStyle(fontSize: 12),),
                                  ],
                                )
                              ],
                            ),
                            Spacer(),
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
                      //histori booking ke2
                      Container(
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10)
                        ),
                        child: Row(
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
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('President Hotel', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),),
                                Text('Greek', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10),),
                                Row(
                                  children: [
                                    Text('Rp 450.000', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),),
                                    Text(' / night', style: TextStyle(fontSize: 12),),
                                  ],
                                )
                              ],
                            ),
                            Spacer(),
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
                      //histori booking ke3
                      Container(
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10)
                        ),
                        child: Row(
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
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('President Hotel', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),),
                                Text('Greek', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10),),
                                Row(
                                  children: [
                                    Text('Rp 450.000', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),),
                                    Text(' / night', style: TextStyle(fontSize: 12),),
                                  ],
                                )
                              ],
                            ),
                            Spacer(),
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
                      //histori booking ke4
                      Container(
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10)
                        ),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.asset(
                                  'assets/images/hotel8.jpg',
                                  width: 80,
                                  height: 80,
                                  fit: BoxFit.cover
                              ),
                            ),
                            SizedBox(width: 10,),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('President Hotel', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),),
                                Text('Greek', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10),),
                                Row(
                                  children: [
                                    Text('Rp 450.000', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),),
                                    Text(' / night', style: TextStyle(fontSize: 12),),
                                  ],
                                )
                              ],
                            ),
                            Spacer(),
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
                      //histori booking ke2
                      Container(
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10)
                        ),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.asset(
                                  'assets/images/hotel9.jpg',
                                  width: 80,
                                  height: 80,
                                  fit: BoxFit.cover
                              ),
                            ),
                            SizedBox(width: 10,),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('President Hotel', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),),
                                Text('Greek', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10),),
                                Row(
                                  children: [
                                    Text('Rp 450.000', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),),
                                    Text(' / night', style: TextStyle(fontSize: 12),),
                                  ],
                                )
                              ],
                            ),
                            Spacer(),
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
                      //histori booking ke10
                      Container(
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10)
                        ),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.asset(
                                  'assets/images/hotel10.jpg',
                                  width: 80,
                                  height: 80,
                                  fit: BoxFit.cover
                              ),
                            ),
                            SizedBox(width: 10,),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('President Hotel', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),),
                                Text('Greek', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10),),
                                Row(
                                  children: [
                                    Text('Rp 450.000', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),),
                                    Text(' / night', style: TextStyle(fontSize: 12),),
                                  ],
                                )
                              ],
                            ),
                            Spacer(),
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
                    ],
                  ),
                )
              ],
            )
          ),
        ),
      ),
    );
  }
}

//class untuk simpan tombol2 untuk filtering
class Filtering{
  String button;

  //variabel pengatur kondisi filteringnya
  bool filter;

  //constructor
  Filtering({
    required this.button,
    this.filter=false
  });
}