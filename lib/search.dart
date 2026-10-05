import 'package:flutter/material.dart';
import 'package:hotelapps/classfiltering.dart';
import 'package:hotelapps/main.dart';
import 'package:hotelapps/profile.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  Widget build(BuildContext context) {
    // mengambil ukuran layar
    final screenWidth = MediaQuery.of(context).size.width;
    //jika lebar >600 dianggap layarnya lebar/besar
    final isLargeScreen = screenWidth > 600;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          //basee container
          child: Container(
            padding: EdgeInsets.all(20),
            color: Colors.grey[200],
            child: Column(
              children: [
                //search bar
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
                      SizedBox(width: 10),
                    ],
                  ),
                ),
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
                //History Booking
                Container(
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
                ) // sini
              ],
            ),
          ),
        )
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
            // Navigator.push(context, MaterialPageRoute(builder: (context) => const SearchPage()),
            // );
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