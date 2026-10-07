import 'package:flutter/material.dart';
import 'package:hotelapps/class_list.dart';
import 'package:hotelapps/search.dart';


// body: Text(widget.hotel.name),

class DetailPage extends StatefulWidget {
  //hal baru di sini
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