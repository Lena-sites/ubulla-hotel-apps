import 'package:flutter/material.dart';
import 'package:hotelapps/models/hotels.dart';
import 'package:hotelapps/ui/screens/custom.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:hotelapps/models/hotelrooms.dart';
import 'package:hotelapps/services/hotelroom_service.dart';
import 'package:hotelapps/models/hotelgallery.dart';
import 'package:hotelapps/services/hotelgalerry_service.dart';

class DetailPage extends StatefulWidget {
  //mengambil data hotel yang telah dipilih sebelumnya di search page
  final Hotels hotel;
  const DetailPage({super.key, required this.hotel});

  @override
  State<DetailPage> createState() => _DetailPage();
}

class _DetailPage extends State<DetailPage> {
  //PENAMPILAN TIPE KAMAR (ROOMS)
  final HotelRoomService hotelRoomService = HotelRoomService();

  // PENAMPILAN GALERI HOTEL
  final HotelGalleryService hotelGalleryService = HotelGalleryService();
  List<HotelGallery> hotelGallery = [];
  bool isLoadingGallery = true;

  List<HotelRooms> hotelRooms = [];
  HotelRooms? selectedRoom;
  bool isLoadingRooms = true;

  //8000 jadi 8.000 ada titiknya
  String formatRupiah(int harga) {
    return harga.toString().replaceAllMapped(
      RegExp(r'\B(?=(\d{3})+(?!\d))'),
          (match) => '.',
    );
  }

  //untuk buka gmapsnya
  Future<void> bukaGoogleMaps() async {
    final latitude = widget.hotel.latitude;
    final longitude = widget.hotel.longitude;

    final url = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude',
    );

    if (await canLaunchUrl(url)) {
      await launchUrl(
        url,
        mode: LaunchMode.externalApplication,
      );
    }
  }

  //LOAD DATA TIPE KAMAR (ROOM)
  @override
  void initState() {
    super.initState();
    loadHotelRooms();
    loadHotelGallery();
  }

  Future<void> loadHotelRooms() async {
    try {
      final rooms = await hotelRoomService.getHotelRooms(widget.hotel.id);

      if (!mounted) return;

      setState(() {
        hotelRooms = rooms;

        if (rooms.isNotEmpty) {
          selectedRoom = rooms.firstWhere(
                (room) => room.roomType == 'Standard' && room.totalRooms > 0,
            orElse: () => rooms.firstWhere(
                  (room) => room.totalRooms > 0,
              orElse: () => rooms.first,
            ),
          );
        }

        isLoadingRooms = false;
      });
    } catch (e) {
      debugPrint('Gagal mengambil tipe kamar: $e');

      if (!mounted) return;

      setState(() {
        isLoadingRooms = false;
      });
    }
  }

  //fungsi untuk mengambil foto galeri hotel
  Future<void> loadHotelGallery() async {
    try {
      final photos = await hotelGalleryService.getHotelGallery(
        widget.hotel.id,
      );

      if (!mounted) return;

      setState(() {
        hotelGallery = photos;
        isLoadingGallery = false;
      });
    } catch (e) {
      debugPrint('Gagal mengambil foto galeri: $e');

      if (!mounted) return;

      setState(() {
        isLoadingGallery = false;
      });
    }
  }

  IconData getFacilityIcon(String facility) {
    switch (facility) {
      case 'Swimming Pool':
        return Icons.pool;
      case 'WiFi':
        return Icons.wifi;
      case 'Restaurant':
        return Icons.restaurant;
      case 'Parking':
        return Icons.local_parking;
      case 'Meeting Room':
        return Icons.door_sliding;
      case 'Fitness Center':
        return Icons.fitness_center;
      default:
        return Icons.check_circle_outline;
    }
  }

  @override
  Widget build(BuildContext context){

    // mengambil ukuran layar
    final screenWidth = MediaQuery.of(context).size.width;
    final room = selectedRoom;

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
              // Foto hotel dari Supabase
              Image.network(
                widget.hotel.imageUrl,
                width: double.infinity,
                height: 250,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: double.infinity,
                    height: 250,
                    color: Colors.grey.shade300,
                    child: Icon(
                      Icons.image_not_supported,
                      color: Colors.grey,
                      size: 50,
                    ),
                  );
                },
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
                        Text('${widget.hotel.city}, ${widget.hotel.country}'),
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
                    if (isLoadingGallery)
                      Center(
                        child: CircularProgressIndicator(),
                      )
                    else if (hotelGallery.isEmpty)
                      Container(
                        height: 100,
                        alignment: Alignment.center,
                        child: Text('Belum ada foto galeri'),
                      )
                    else
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: hotelGallery.map((photo) {
                            return Padding(
                              padding: EdgeInsets.only(right: 15),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(30),
                                child: Image.network(
                                  photo.imageUrl,
                                  width: 190,
                                  height: 190,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      width: 190,
                                      height: 190,
                                      color: Colors.grey.shade300,
                                      child: Icon(
                                        Icons.image_not_supported,
                                        color: Colors.grey,
                                      ),
                                    );
                                  },
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    Divider(color: Colors.grey[300], thickness: 1,height: 30,),
                    SizedBox(height: 20,),
                    Text('Details', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
                    SizedBox(height: 5,),
                    //Deskripsi
                    Text(
                      widget.hotel.details.isNotEmpty
                          ? widget.hotel.details
                          : 'Deskripsi hotel belum tersedia.',
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade700,
                        height: 1.5,
                      ),
                    ),
                    SizedBox(height: 15,),
                    Text('Facilities', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
                    SizedBox(height: 5,),
                    //fasilitas
                    Wrap(
                      alignment: WrapAlignment.start,
                      spacing: 25,
                      runSpacing: 20,
                      children: widget.hotel.facilities.map((facility) {
                        return Column(
                          children: [
                            Icon(
                              getFacilityIcon(facility),
                              color: Colors.green,
                              size: 35,
                            ),
                            Text(facility),
                          ],
                        );
                      }).toList(),
                    ),
                    //menampilkan tipe kamar

                    SizedBox(height: 20),

                    Text(
                      'Room Type',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    SizedBox(height: 10),

                    if (isLoadingRooms)
                      Center(child: CircularProgressIndicator())
                    else if (hotelRooms.isEmpty)
                      Text('Tipe kamar belum tersedia')
                    else
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: hotelRooms.map((room) {
                          final isSelected = selectedRoom?.id == room.id;
                          final isAvailable = room.totalRooms > 0;

                          return GestureDetector(
                            onTap: isAvailable
                                ? () {
                              setState(() {
                                selectedRoom = room;
                              });
                            }
                                : null,
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              decoration: BoxDecoration(
                                color: !isAvailable
                                    ? Colors.grey[300]
                                    : isSelected
                                    ? Colors.green
                                    : Colors.white,
                                border: Border.all(
                                  color: !isAvailable
                                      ? Colors.grey
                                      : Colors.green,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    room.roomType,
                                    style: TextStyle(
                                      color: !isAvailable
                                          ? Colors.grey
                                          : isSelected
                                          ? Colors.white
                                          : Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    isAvailable
                                        ? '${room.totalRooms} rooms available'
                                        : 'Sold Out',
                                    style: TextStyle(
                                      color: !isAvailable
                                          ? Colors.red
                                          : isSelected
                                          ? Colors.white
                                          : Colors.black,
                                      fontSize: 12,
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    'Rp ${formatRupiah(room.pricePerNight)}',
                                    style: TextStyle(
                                      color: !isAvailable
                                          ? Colors.grey
                                          : isSelected
                                          ? Colors.white
                                          : Colors.black,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    SizedBox(height: 15,),
                    Text('Location', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
                    SizedBox(height: 5,),
                    //LOKASINYAA
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 220,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: FlutterMap(
                              options: MapOptions(
                                initialCenter: LatLng(
                                  widget.hotel.latitude,
                                  widget.hotel.longitude,
                                ),
                                initialZoom: 15,
                              ),
                              children: [
                                TileLayer(
                                  urlTemplate:
                                  'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                                  userAgentPackageName: 'com.example.hotelapps',
                                ),
                                MarkerLayer(
                                  markers: [
                                    Marker(
                                      point: LatLng(
                                        widget.hotel.latitude,
                                        widget.hotel.longitude,
                                      ),
                                      width: 50,
                                      height: 50,
                                      child: Icon(
                                        Icons.location_on,
                                        color: Colors.red,
                                        size: 40,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),

                        SizedBox(height: 10),

                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: bukaGoogleMaps,
                            icon: Icon(Icons.directions),
                            label: Text('Open in Google Maps'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              foregroundColor: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    )
                    // ClipRRect(
                    //   borderRadius: BorderRadius.circular(30),
                    //   child: Image.asset(
                    //       'assets/images/maps.jpg',
                    //       width: screenWidth,
                    //       height: 230,
                    //       fit: BoxFit.cover
                    //   ),
                    // ),
                  ],
                ),
              ),
              //pilihan lanjut ke proses booking
              if (isLoadingRooms) //loading sampai datanya ada dulu
                Container(
                  width: screenWidth,
                  height: 70,
                  color: Colors.grey[400],
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                ) else
              Container( //ttampilan
                width: screenWidth,
                height: 70,
                color: Colors.grey[400],
                padding: EdgeInsets.all(20),
                child: Row(
                  children: [
                    Text('Rp ${formatRupiah(selectedRoom!.pricePerNight)}', style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),),
                    Text(' / night', style: TextStyle(fontSize: 12),),
                    Spacer(),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => CustomPage(hotel: widget.hotel, selectedRoom: selectedRoom!),), //mempassing data hotel ke halaman custom
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