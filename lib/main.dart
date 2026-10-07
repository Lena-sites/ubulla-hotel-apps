import 'package:flutter/material.dart';
import 'package:hotelapps/booking.dart';
import 'package:hotelapps/class_list.dart';
import 'package:hotelapps/profile.dart';
import 'package:hotelapps/search.dart';
import 'package:hotelapps/onboarding.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const OnboardingPage(),
    );
  }
}

class HomePage extends StatefulWidget{
  const HomePage({super.key});
  @override
  State<StatefulWidget> createState()=>_MyAppState();
}

class _MyAppState extends State<HomePage>{

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
        automaticallyImplyLeading: false, //matiin tanda panah back otomatis
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
                //History Booking
                Container(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    children: [
                      //histori 1
                      GestureDetector(
                        onDoubleTap: (){
                          setState(() {
                            hotellist[0].save=true;
                          });
                        },
                        child: Container(
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
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(hotellist[0].name,
                                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                                    ),
                                    Text(hotellist[0].location, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10),),
                                    Row(
                                      children: [
                                        Text('Rp ${hotellist[0].price}', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),),
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
                                        GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              hotellist[0].save = !hotellist[0].save;
                                            });
                                          },
                                          child: Container(
                                            child: Icon(
                                              hotellist[0].save ? Icons.bookmark : Icons.bookmark_border_outlined,
                                              color: hotellist[0].save ? Colors.green : Colors.black,
                                            ),
                                          ),
                                        )
                                      ],
                                    );
                                  }
                              ),
                              SizedBox(width: 10,)
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 20,),
                      //histori booking ke2
                      GestureDetector(
                        onDoubleTap: (){
                          setState(() {
                            hotellist[1].save=true;
                          });
                        },
                        child: Container(
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
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(hotellist[1].name,
                                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                                    ),
                                    Text(hotellist[1].location, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10),),
                                    Row(
                                      children: [
                                        Text('Rp ${hotellist[1].price}', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),),
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
                                        GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              hotellist[1].save = !hotellist[1].save;
                                            });
                                          },
                                          child: Container(
                                            child: Icon(
                                              hotellist[1].save ? Icons.bookmark : Icons.bookmark_border_outlined,
                                              color: hotellist[1].save ? Colors.green : Colors.black,
                                            ),
                                          ),
                                        )
                                      ],
                                    );
                                  }
                              ),
                              SizedBox(width: 10,)
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 20,),
                      //histori booking ke3
                      GestureDetector(
                        onDoubleTap: (){
                          setState(() {
                            hotellist[2].save=true;
                          });
                        },
                        child: Container(
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
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(hotellist[2].name,
                                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                                    ),
                                    Text(hotellist[2].location, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10),),
                                    Row(
                                      children: [
                                        Text('Rp ${hotellist[2].price}', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),),
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
                                        GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              hotellist[2].save = !hotellist[2].save;
                                            });
                                          },
                                          child: Container(
                                            child: Icon(
                                              hotellist[2].save ? Icons.bookmark : Icons.bookmark_border_outlined,
                                              color: hotellist[2].save ? Colors.green : Colors.black,
                                            ),
                                          ),
                                        )
                                      ],
                                    );
                                  }
                              ),
                              SizedBox(width: 10,)
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 20,),
                      //histori booking ke4
                      GestureDetector(
                        onDoubleTap: (){
                          setState(() {
                            hotellist[3].save=true;
                          });
                        },
                        child: Container(
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
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(hotellist[3].name,
                                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                                    ),
                                    Text(hotellist[3].location, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10),),
                                    Row(
                                      children: [
                                        Text('Rp ${hotellist[3].price}', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),),
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
                                        GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              hotellist[3].save = !hotellist[3].save;
                                            });
                                          },
                                          child: Container(
                                            child: Icon(
                                              hotellist[3].save ? Icons.bookmark : Icons.bookmark_border_outlined,
                                              color: hotellist[3].save ? Colors.green : Colors.black,
                                            ),
                                          ),
                                        )
                                      ],
                                    );
                                  }
                              ),
                              SizedBox(width: 10,)
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 20,),
                      //histori booking ke5
                      GestureDetector(
                        onDoubleTap: (){
                          setState(() {
                            hotellist[4].save=true;
                          });
                        },
                        child: Container(
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
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(hotellist[4].name,
                                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                                    ),
                                    Text(hotellist[4].location, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10),),
                                    Row(
                                      children: [
                                        Text('Rp ${hotellist[4].price}', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),),
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
                                        GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              hotellist[4].save = !hotellist[4].save;
                                            });
                                          },
                                          child: Container(
                                            child: Icon(
                                              hotellist[4].save ? Icons.bookmark : Icons.bookmark_border_outlined,
                                              color: hotellist[4].save ? Colors.green : Colors.black,
                                            ),
                                          ),
                                        )
                                      ],
                                    );
                                  }
                              ),
                              SizedBox(width: 10,)
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 20,),
                      //histori booking ke6
                      GestureDetector(
                        onDoubleTap: (){
                          setState(() {
                            hotellist[5].save=true;
                          });
                        },
                        child: Container(
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
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(hotellist[5].name,
                                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                                    ),
                                    Text(hotellist[5].location, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10),),
                                    Row(
                                      children: [
                                        Text('Rp ${hotellist[5].price}', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),),
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
                                        GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              hotellist[5].save = !hotellist[5].save;
                                            });
                                          },
                                          child: Container(
                                            child: Icon(
                                              hotellist[5].save ? Icons.bookmark : Icons.bookmark_border_outlined,
                                              color: hotellist[5].save ? Colors.green : Colors.black,
                                            ),
                                          ),
                                        )
                                      ],
                                    );
                                  }
                              ),
                              SizedBox(width: 10,)
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ) // sini
              ],
            )
          ),
        ),
      ),
    //tempat navigasi
    bottomNavigationBar: BottomNavigationBar(
      currentIndex: 0,
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