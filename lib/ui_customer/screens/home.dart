import 'package:flutter/material.dart';
import 'package:hotelapps/ui_customer/widgets/navigation.dart';
import 'package:hotelapps/services/hotel_service.dart';
import 'package:hotelapps/services/user_service.dart';
import 'package:hotelapps/models/hotels.dart';
import 'package:hotelapps/ui_customer/screens/detail.dart';
import 'package:hotelapps/services/transaction_service.dart';


class HomePage extends StatefulWidget{
  const HomePage({super.key});
  @override
  State<StatefulWidget> createState()=>_MyAppState();
}

class _MyAppState extends State<HomePage>{

  List<Hotels> fiveStarHotels = [];
  bool isLoading = true;

  List<Map<String, dynamic>> recentTransactions = [];
  bool isTransactionLoading = true;
  bool showAllTransactions = false;

  @override
  void initState() {
    super.initState();
    loadFiveStarHotels();
    loadRecentTransactions();
  }

  Future<void> loadFiveStarHotels() async {
    try {
      final data = await HotelService().getFiveStarHotels();

      setState(() {
        fiveStarHotels = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });

      debugPrint('Gagal mengambil hotel bintang 5: $e');
    }
  }

  Future<void> loadRecentTransactions() async {
    try {
      final data = await TransactionService().getActiveTransactions();

      if (!mounted) return;

      setState(() {
        recentTransactions = data;
        isTransactionLoading = false;
      });
    } catch (e) {
      debugPrint('Gagal mengambil transaksi: $e');

      if (!mounted) return;

      setState(() {
        isTransactionLoading = false;
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
  Widget build(BuildContext context){

    // mengambil ukuran layar
    final screenWidth = MediaQuery.of(context).size.width;
    //jika lebar >600 dianggap layarnya lebar/besar
    final isLargeScreen = screenWidth > 600;

    //ambil hasil pengambilan di /services
    final userService = UserService();
    final username = userService.getUsername();

    //menentukan jumlah transaksi yang ditampilkan berdasarkan kondisi tombol
    final displayedTransactions = showAllTransactions
        ? recentTransactions
        : recentTransactions.take(3).toList(); //ambil 3 dulu

    //dark atau light mode
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF121212) : Colors.grey[200];
    final cardColor = Theme.of(context).cardColor;

    final placeholderColor = isDark
        ? const Color(0xFF333333)
        : Colors.grey[300];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
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
          ],
        ),
        automaticallyImplyLeading: false, //matiin tanda panah back otomatis
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          //container terluar (basenya)
          child: Container(
              width: double.infinity,
              color: bgColor,
              child: Column(
                children: [
                  //container untuk menampung "hello.." dan search bar"
                  Container(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Welcome, $username!',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 10),
                      ],
                    ),
                  ),
                  //item2 hotel hasil dari filtering dan bisa di scroll ke samping

                  if (isLoading)
                    const Center(child: CircularProgressIndicator())
                  else if (fiveStarHotels.isEmpty)
                    const Center(child: Text('Belum ada hotel bintang 5'))
                  else
                    SizedBox(
                      height: 260,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: fiveStarHotels.length,
                        itemBuilder: (context, index) {
                          final hotel = fiveStarHotels[index];

                          return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => DetailPage(hotel: hotel),
                                  ),
                                );
                              },
                            child:Container(
                              width: 190,
                              margin: EdgeInsets.only(
                                left: index == 0 ? 20 : 0,
                                right: 20,
                              ),
                              child: Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(30),
                                    child: Image.network(
                                      hotel.imageUrl,
                                      width: 190,
                                      height: 260,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) {
                                        return Container(
                                          width: 190,
                                          height: 260,
                                          color: Colors.grey[400],
                                          child: const Icon(Icons.hotel, size: 50),
                                        );
                                      },
                                    ),
                                  ),

                                  // Rating
                                  Positioned(
                                    top: 12,
                                    right: 12,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 7,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.green,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Row(
                                        children: [
                                          const Icon(
                                            Icons.star,
                                            color: Colors.white,
                                            size: 13,
                                          ),
                                          const SizedBox(width: 5),
                                          Text(
                                            '${hotel.hotelStars}',
                                            style: const TextStyle(
                                              fontSize: 12,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),

                                  // Informasi hotel
                                  Positioned(
                                    bottom: 12,
                                    left: 12,
                                    right: 12,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          hotel.name,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          '${hotel.city}, ${hotel.country}',
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 10,
                                          ),
                                        ),
                                        Text(
                                          'Rp ${formatRupiah(hotel.pricePerNight)} / night',
                                          style: TextStyle(
                                            fontSize: 13,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            )
                          );
                        },
                      ),
                    ),
                  SizedBox(height: 20,),
                  //tulisan Recenlty Booked dan see all
                  Row(
                    children: [
                      SizedBox(width: 20),
                      Text(
                        'Recently Booked',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Spacer(),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            showAllTransactions = !showAllTransactions;
                          });
                        },
                        child: Text(
                          showAllTransactions ? 'See Less' : 'See All',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                    ],
                  ),
                  //History Booking
                  Container(
                    padding: EdgeInsets.all(20),
                    child:
                    Column(
                      children: [
                        if (isTransactionLoading)
                          const Center(child: CircularProgressIndicator())
                        else if (displayedTransactions.isEmpty)
                          const Center(
                            child: Text('Belum ada riwayat booking'),
                          )
                        else
                          ...displayedTransactions.map((transaction) {

                            // Mengambil data kamar
                            final roomData =
                            transaction['hotel_rooms'] as Map<String, dynamic>?;

                            // Mengambil data harga kamar
                            final priceData =
                            roomData?['hotel_prices'] as Map<String, dynamic>?;

                            final roomPrice =
                                (priceData?['price_per_night'] as num?)?.toInt() ?? 0;

                            // Mengambil data hotel
                            final hotelData =
                            roomData?['hotels'] as Map<String, dynamic>?;

                            if (hotelData == null) {
                              return const SizedBox.shrink();
                            }

                            //DetailPage membutuhkan objek Hotels, bukan sekadar nama dan foto hotel
                            final selectedHotel = Hotels.fromJson(
                              Map<String, dynamic>.from(hotelData),
                            );

                            final hotelImage =
                                hotelData?['image_url'] as String? ?? '';

                            final hotelCity =
                                hotelData?['city'] as String? ?? '';

                            final hotelCountry =
                                hotelData?['country'] as String? ?? '';

                            final hotelName =
                                transaction['hotel_name']?.toString() ?? 'Hotel';

                            final roomType =
                                roomData?['room_type']?.toString() ?? 'Room';

                            return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => DetailPage(
                                        hotel: selectedHotel,
                                      ),
                                    ),
                                  );
                                },
                                child: Container(
                                  margin: const EdgeInsets.only(bottom: 20),
                                  padding: const EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                    color: cardColor,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Row(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: hotelImage.isNotEmpty
                                            ? Image.network(
                                          hotelImage,
                                          width: 80,
                                          height: 80,
                                          fit: BoxFit.cover,
                                          errorBuilder: (context, error, stackTrace) {
                                            return Container(
                                              width: 80,
                                              height: 80,
                                              color: placeholderColor,
                                              child: Icon(Icons.hotel),
                                            );
                                          },
                                        )
                                            : Container(
                                          width: 80,
                                          height: 80,
                                          color: placeholderColor,
                                          child: Icon(Icons.hotel),
                                        ),
                                      ),
                                      SizedBox(width: 10),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              hotelName,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15,
                                              ),
                                            ),
                                            Text(
                                              '$hotelCity, $hotelCountry',
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 10,
                                              ),
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                  'Rp ${formatRupiah(roomPrice)}',
                                                  style: const TextStyle(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                const Text(
                                                  ' / night',
                                                  style: TextStyle(fontSize: 12),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      //tampilin room type yg dia pesen
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 10,
                                          vertical: 8,
                                        ),
                                        decoration: BoxDecoration(
                                          color: isDark ? Color(0xFF164B38) : Colors.green.shade50,
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: Text(
                                          roomType,
                                          style: TextStyle(
                                            color: isDark
                                                ? Colors.green.shade100
                                                : Colors.green.shade800,
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                            );
                          }),
                      ],
                    )
                  ) // sini
                ],
              )
          ),
        ),
      ),
      //tempat navigasi
      bottomNavigationBar: BottomNavigation(currentIndex: 0),
    );
  }
}