import 'package:flutter/material.dart';
import 'package:hotelapps/class_list.dart';
import 'package:hotelapps/custom.dart';


class DetailPage extends StatefulWidget {
  //mengambil data hotel yang telah dipilih sebelumnya di search page
  final HotelList hotel;
  const DetailPage({super.key, required this.hotel});

  @override
  State<DetailPage> createState() => _DetailPage();
}

class _DetailPage extends State<DetailPage> {
  @override
  Widget build(BuildContext context){

    // mengambil ukuran layar
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //ini buat tampilin foto aja untuk 2 hotel teratas, yang lain sisanya ga ada foto
              if (widget.hotel.name == 'Four Seasons Resort Bali at Jimbaran Bay')
                Image.asset(
                  'assets/images/hotel5.jpg',
                  width: double.infinity,
                  height: 250,
                  fit: BoxFit.cover,
                ),
              if (widget.hotel.name == 'Amanjiwo')
                Image.asset(
                  'assets/images/hotel6.jpg',
                  width: double.infinity,
                  height: 250,
                  fit: BoxFit.cover,
                ),
              SizedBox(height: 10,),
              //container pembungkus elemen2 yang di bawah foto
              Container(
                padding: EdgeInsets.all(25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.hotel.name, style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold)),
                    Row(
                      children: [
                        Icon(Icons.location_on_sharp, color: Colors.red),
                        SizedBox(width: 5),
                        Text(widget.hotel.location),
                      ],
                    ),
                    SizedBox(height: 10,),
                    //buat nambah garis abu2
                    Divider(color: Colors.grey[300], thickness: 1,height: 30,),
                    Row(
                      children: [
                        Text('Gallery Photos', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
                        Spacer(),
                        Text('See All', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),)
                      ],
                    ),
                    SizedBox(height: 5,),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(30),
                            child: Image.asset(
                                'assets/images/fasilitas1.jpg',
                                width: 190,
                                height: 190,
                                fit: BoxFit.cover
                            ),
                          ),
                          SizedBox(width: 15,),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(30),
                            child: Image.asset(
                                'assets/images/fasilitas2.jpg',
                                width: 190,
                                height: 190,
                                fit: BoxFit.cover
                            ),
                          ),
                          SizedBox(width: 15,),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(30),
                            child: Image.asset(
                                'assets/images/fasilitas3.jpg',
                                width: 190,
                                height: 190,
                                fit: BoxFit.cover
                            ),
                          ),
                          SizedBox(width: 15,),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(30),
                            child: Image.asset(
                                'assets/images/fasilitas4.jpg',
                                width: 190,
                                height: 190,
                                fit: BoxFit.cover
                            ),
                          ),
                          SizedBox(width: 15,),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(30),
                            child: Image.asset(
                                'assets/images/fasilitas5.jpg',
                                width: 190,
                                height: 190,
                                fit: BoxFit.cover
                            ),
                          ),
                        ],
                      ),
                    ),
                    Divider(color: Colors.grey[300], thickness: 1,height: 30,),
                    SizedBox(height: 20,),
                    Text('Details', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
                    SizedBox(height: 5,),
                    //Deskripsi
                    Text('Offers a comfortable and relaxing stay in the heart of this room. Featuring modern rooms, cozy facilities, and convenient access to popular attractions, this hotel is a great choice for both business and leisure travelers. Enjoy a pleasant atmosphere, quality service, and a memorable stay.',
                      textAlign: TextAlign.justify,
                    ),
                    SizedBox(height: 15,),
                    Text('Facilities', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
                    SizedBox(height: 5,),
                    //fasilitas
                    Wrap(
                      alignment: WrapAlignment.start,
                      spacing: 25, //jarak kiri kanan
                      runSpacing: 20, //jarak atas bawah
                      children: [
                        Column(
                          children: [
                            Icon(Icons.pool, color: Colors.green, size: 35),
                            Text('Swimming Pool')
                          ],
                        ),
                        Column(
                          children: [
                            Icon(Icons.wifi, color: Colors.green,size: 35),
                            Text('WiFi')
                          ],
                        ),
                        Column(
                          children: [
                            Icon(Icons.restaurant, color: Colors.green,size: 35),
                            Text('Restaurant')
                          ],
                        ),
                        Column(
                          children: [
                            Icon(Icons.local_parking, color: Colors.green,size: 35),
                            Text('Parking')
                          ],
                        ),
                        Column(
                          children: [
                            Icon(Icons.door_sliding, color: Colors.green,size: 35),
                            Text('Meeting Room')
                          ],
                        ),
                        Column(
                          children: [
                            Icon(Icons.fitness_center, color: Colors.green,size: 35),
                            Text('Fitness Center')
                          ],
                        )
                      ],
                    ),
                    SizedBox(height: 15,),
                    Text('Location', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
                    SizedBox(height: 5,),
                    //ini maps dummy ya
                    ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: Image.asset(
                          'assets/images/maps.jpg',
                          width: screenWidth,
                          height: 230,
                          fit: BoxFit.cover
                      ),
                    ),
                  ],
                ),
              ),
              //pilihan lanjut ke proses booking
              Container(
                width: screenWidth,
                height: 70,
                color: Colors.grey[400],
                padding: EdgeInsets.all(20),
                child: Row(
                  children: [
                    Text('Rp ${widget.hotel.price}', style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),),
                    Text(' / night', style: TextStyle(fontSize: 12),),
                    Spacer(),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => CustomPage(hotel: widget.hotel),), //mempassing data hotel ke halaman custom
                        );
                      },
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                      child: Text('Book Now!', style: TextStyle(color: Colors.white),),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}