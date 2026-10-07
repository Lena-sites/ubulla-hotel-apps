import 'package:flutter/material.dart';
import 'package:hotelapps/booking.dart';
import 'package:hotelapps/class_list.dart';
import 'package:hotelapps/detail.dart';
import 'package:hotelapps/main.dart';
import 'package:hotelapps/profile.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String notifText='';
  bool showNotif=false;
  bool selected=false;

  @override
  Widget build(BuildContext context) {

    // mengambil ukuran layar
    final screenWidth = MediaQuery.of(context).size.width;
    //jika lebar >600 dianggap layarnya lebar/besar
    final isLargeScreen = screenWidth > 600;

    return Scaffold(
      appBar: AppBar( //di jadiin search bar
        backgroundColor: Colors.grey[200],
        title: Container(
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
              SizedBox(width: 10),
            ],
          ),
        ),
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              //basee container
              child: Container(
                padding: EdgeInsets.all(20),
                color: Colors.grey[200],
                child: Column(
                  children: [
                    //bagian tombol2 filtering
                    //Row ini bisa scroll ke samping
                    SizedBox(height: 30,),
                    SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child:Row(
                          children: [
                            SizedBox(width: 20,),
                            //RECOMMENDED
                            ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  filtering[4].filter = !filtering[4].filter;
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: filtering[4].filter ? Color(0xFF10B981) : Colors.white, // Background hijau / putih
                                side: BorderSide(
                                  color: Colors.green, // Warna border hijau untuk kedua kondisi
                                  width: 1.5,
                                ),
                              ),
                              child: Text('All', style: TextStyle(
                                color: filtering[4].filter? Colors.white: Colors.green,
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                              ),
                            ),
                            SizedBox(width: 15,),
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
                    SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded( // mengikuti lebar sisa layar
                          child: Text(
                            'Recommended (580.000)',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 5,),
                    //list hotel
                    //hotel ke 1
                    Container(
                      child: Column(
                        children: [
                          //hotel 1
                          GestureDetector(
                            onLongPress: (){
                              setState(() {
                                notifText='${hotellist[0].name} telah dipilih!';
                                hotellist[0].selected=true;
                              });
                              Future.delayed(Duration(seconds: 3),(){
                                if(mounted){
                                  setState(() {
                                    notifText='';
                                  });
                                }
                              });
                            },
                            onTap: (){
                              if(hotellist[0].selected){
                                //tap buat batalin pilihann haasil longpress tadi
                                setState(() {
                                  hotellist[0].selected=false;
                                });
                              } else {
                                //kondisi belum longpress, pas di onetap langsung ke detailpage
                                Navigator.push(context, MaterialPageRoute(builder: (context)=>DetailPage(hotel:hotellist[0]),)
                                );
                              }
                            },
                            child: Container(
                              padding: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                border: hotellist[0].selected? Border.all(color: Colors.blue, width: 2): Border.all(color: Colors.transparent),
                                color: hotellist[0].selected? Colors.blue[100]: Colors.white,
                                borderRadius: BorderRadius.circular(10),
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
                                            Icon(Icons.bookmark_border_outlined)
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
                          //hotel ke2
                          GestureDetector(
                            onLongPress: (){
                              setState(() {
                                notifText='${hotellist[1].name} telah dipilih!';
                                hotellist[1].selected=true;
                              });
                              Future.delayed(Duration(seconds: 3),(){
                                if(mounted){
                                  setState(() {
                                    notifText='';
                                  });
                                }
                              });
                            },
                            onTap: (){
                              if(hotellist[1].selected){
                                //tap buat batalin pilihann haasil longpress tadi
                                setState(() {
                                  hotellist[1].selected=false;
                                });
                              } else {
                                //kondisi belum longpress, pas di onetap langsung ke detailpage
                                Navigator.push(context, MaterialPageRoute(builder: (context)=>DetailPage(hotel:hotellist[1]),)
                                );
                              }
                            },
                            child: Container(
                              padding: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                border: hotellist[1].selected? Border.all(color: Colors.blue, width: 2): Border.all(color: Colors.transparent),
                                color: hotellist[1].selected? Colors.blue[100]: Colors.white,
                                borderRadius: BorderRadius.circular(10),
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
                                            Icon(Icons.bookmark_border_outlined)
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
                          //hotel ke3
                          GestureDetector(
                            onLongPress: (){
                              setState(() {
                                notifText='${hotellist[2].name} telah dipilih!';
                                hotellist[2].selected=true;
                              });
                              Future.delayed(Duration(seconds: 3),(){
                                if(mounted){
                                  setState(() {
                                    notifText='';
                                  });
                                }
                              });
                            },
                            onTap: (){
                              if(hotellist[2].selected){
                                //tap buat batalin pilihann haasil longpress tadi
                                setState(() {
                                  hotellist[2].selected=false;
                                });
                              } else {
                                //kondisi belum longpress, pas di onetap langsung ke detailpage
                                Navigator.push(context, MaterialPageRoute(builder: (context)=>DetailPage(hotel:hotellist[2]),)
                                );
                              }
                            },
                            child: Container(
                              padding: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                border: hotellist[2].selected? Border.all(color: Colors.blue, width: 2): Border.all(color: Colors.transparent),
                                color: hotellist[2].selected? Colors.blue[100]: Colors.white,
                                borderRadius: BorderRadius.circular(10),
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
                                            Icon(Icons.bookmark_border_outlined)
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
                          //hotel ke4
                          GestureDetector(
                            onLongPress: (){
                              setState(() {
                                notifText='${hotellist[3].name} telah dipilih!';
                                hotellist[3].selected=true;
                              });
                              Future.delayed(Duration(seconds: 3),(){
                                if(mounted){
                                  setState(() {
                                    notifText='';
                                  });
                                }
                              });
                            },
                            onTap: (){
                              if(hotellist[3].selected){
                                //tap buat batalin pilihann haasil longpress tadi
                                setState(() {
                                  hotellist[3].selected=false;
                                });
                              } else {
                                //kondisi belum longpress, pas di onetap langsung ke detailpage
                                Navigator.push(context, MaterialPageRoute(builder: (context)=>DetailPage(hotel:hotellist[4]),)
                                );
                              }
                            },
                            child: Container(
                              padding: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                border: hotellist[3].selected? Border.all(color: Colors.blue, width: 2): Border.all(color: Colors.transparent),
                                color: hotellist[3].selected? Colors.blue[100]: Colors.white,
                                borderRadius: BorderRadius.circular(10),
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
                                            Icon(Icons.bookmark_border_outlined)
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
                          //hotel ke5
                          GestureDetector(
                            onLongPress: (){
                              setState(() {
                                notifText='${hotellist[4].name} telah dipilih!';
                                hotellist[4].selected=true;
                              });
                              Future.delayed(Duration(seconds: 3),(){
                                if(mounted){
                                  setState(() {
                                    notifText='';
                                  });
                                }
                              });
                            },
                            onTap: (){
                              if(hotellist[4].selected){
                                //tap buat batalin pilihann haasil longpress tadi
                                setState(() {
                                  hotellist[4].selected=false;
                                });
                              } else {
                                //kondisi belum longpress, pas di onetap langsung ke detailpage
                                Navigator.push(context, MaterialPageRoute(builder: (context)=>DetailPage(hotel:hotellist[4]),)
                                );
                              }
                            },
                            child: Container(
                              padding: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                border: hotellist[4].selected? Border.all(color: Colors.blue, width: 2): Border.all(color: Colors.transparent),
                                color: hotellist[4].selected? Colors.blue[100]: Colors.white,
                                borderRadius: BorderRadius.circular(10),
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
                                            Icon(Icons.bookmark_border_outlined)
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
                          //hotel ke6
                          GestureDetector(
                            onLongPress: (){
                              setState(() {
                                notifText='${hotellist[5].name} telah dipilih!';
                                hotellist[5].selected=true;
                              });
                              Future.delayed(Duration(seconds: 3),(){
                                if(mounted){
                                  setState(() {
                                    notifText='';
                                  });
                                }
                              });
                            },
                            onTap: (){
                              if(hotellist[5].selected){
                                //tap buat batalin pilihann haasil longpress tadi
                                setState(() {
                                  hotellist[5].selected=false;
                                });
                              } else {
                                //kondisi belum longpress, pas di onetap langsung ke detailpage
                                Navigator.push(context, MaterialPageRoute(builder: (context)=>DetailPage(hotel:hotellist[5]),)
                                );
                              }
                            },
                            child: Container(
                              padding: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                border: hotellist[5].selected? Border.all(color: Colors.blue, width: 2): Border.all(color: Colors.transparent),
                                color: hotellist[5].selected? Colors.blue[100]: Colors.white,
                                borderRadius: BorderRadius.circular(10),
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
                                            Icon(Icons.bookmark_border_outlined)
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
                ),
              ),
            ),
            // LAPISAN 2: Banner Notifikasi Melayang (Dipasang paling bawah kode agar menimpa layar)
            if (notifText.isNotEmpty)
              Positioned(
                top: 10,
                left: 20,
                right: 20,
                child: Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Color(0xFF10B981),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    notifText,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
          ],
        ),
      ),
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