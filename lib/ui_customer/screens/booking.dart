import 'package:flutter/material.dart';
import 'package:hotelapps/ui_customer/widgets/navigation.dart';
import 'package:hotelapps/services/transaction_service.dart';
import 'package:hotelapps/models/hotels.dart';
import 'package:hotelapps/services/hotel_service.dart';
import 'package:hotelapps/ui_customer/screens/ticket.dart';

class BookingPage extends StatefulWidget {
  const BookingPage({super.key});

  @override
  State<BookingPage> createState() => _BookingPage();
}

class _BookingPage extends State<BookingPage> {
  // variabel kondisi untuk tombol2 filter status booking
  String selectedStatus = 'ongoing';

  //inisialisasi untuk proses pengambilan data transaksi
  final TransactionService transactionService = TransactionService();
  List<Map<String, dynamic>> transactions = [];
  bool isLoading = true;

  final HotelService hotelService = HotelService();
  Map<int, Hotels> hotelsById = {}; //untuk menyimpan detail hotel berdasarkan ID-nya

  @override
  void initState() {
    super.initState();
    loadTransactions(); //load ato ambil data transaksinya dari supabase
  }

  // function untuk mengambil data transaksi dari Supabase
  Future<void> loadTransactions() async {
    try {
      // mengambil transaksi pengguna
      final data = await transactionService.getTransactions();

      // mengambil detail hotel berdasarkan hotel_id
      Map<int, Hotels> hotelMap = {};

      for (final transaction in data) {
        final hotelId = (transaction['hotel_id'] as num).toInt();

        // supaya hotel yang sama tidak diambil berulang kali (menghemat proses pengambilan data)
        if (!hotelMap.containsKey(hotelId)) {
          try {
            final hotel = await hotelService.getHotelById(hotelId);
            hotelMap[hotelId] = hotel;
          } catch (e) {
            debugPrint('Gagal mengambil detail hotel: $e');
          }
        }
      }

      if (!mounted) return;

      setState(() {
        transactions = data;
        hotelsById = hotelMap;
        isLoading = false;
      });

    } catch (e) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal mengambil data booking: $e'),
        ),
      );
    }
  }

  // function untuk memproses pembatalan booking
  Future<void> cancelBooking(int transactionId) async {
    try {
      await transactionService.cancelBooking(transactionId);

      await loadTransactions();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Booking berhasil dibatalkan.'),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal membatalkan booking: $e'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {

    final filteredTransactions = transactions.where((transaction) {
      return transaction['booking_status'] == selectedStatus;
    }).toList();

    return Scaffold(
      backgroundColor: Colors.grey[200],
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
          ],
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          //container terluar (basenya)
          child: Container(
              width: double.infinity,
              child: Column(
                children: [
                  //judul halaman
                  SizedBox(height: 10),
                  Text('My Booking', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),
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
                                selectedStatus = 'ongoing';
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: selectedStatus=='ongoing' ? Color(0xFF10B981) : Colors.white, // Background hijau / putih
                              side: BorderSide(color: Colors.green, width: 1.5) // Warna border hijau untuk kedua kondisi
                            ),
                            child: Text('Ongoing', style: TextStyle(
                              color: selectedStatus == 'ongoing' ? Colors.white: Colors.green,
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
                                selectedStatus = 'completed';
                              });
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: selectedStatus=='completed' ? Color(0xFF10B981) : Colors.white, // Background hijau / putih
                                side: BorderSide(color: Colors.green, width: 1.5) // Warna border hijau untuk kedua kondisi
                            ),
                            child: Text('Completed', style: TextStyle(
                              color: selectedStatus == 'completed' ? Colors.white: Colors.green,
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
                                selectedStatus = 'canceled';
                              });
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: selectedStatus=='canceled' ? Color(0xFF10B981) : Colors.white, // Background hijau / putih
                                side: BorderSide(color: Colors.green, width: 1.5) // Warna border hijau untuk kedua kondisi
                            ),
                            child: Text('Canceled', style: TextStyle(
                              color: selectedStatus == 'canceled' ? Colors.white: Colors.green,
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
                    child: isLoading
                        ? Center(
                      child: CircularProgressIndicator(),
                    )
                        : filteredTransactions.isEmpty
                        ? Center(
                      child: Text(
                        'You have no bookings yet.',
                        style: TextStyle(fontSize: 14),
                      ),
                    )
                        : Column(
                      children: [
                        ...filteredTransactions.map((transaction) {
                          final hotelId =
                          (transaction['hotel_id'] as num).toInt();

                          final hotel = hotelsById[hotelId];

                          if (hotel == null) {
                            return SizedBox();
                          }

                          return Container(
                            margin: EdgeInsets.only(bottom: 20),
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              children: [
                                // gambar + teks
                                Row(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.network(
                                        hotel.imageUrl,
                                        width: 80,
                                        height: 80,
                                        fit: BoxFit.cover,
                                        errorBuilder: (context, error, stackTrace) {
                                          return Container(
                                            width: 80,
                                            height: 80,
                                            color: Colors.grey.shade300,
                                            child: Icon(
                                              Icons.image_not_supported,
                                              color: Colors.grey,
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            hotel.name,
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15,
                                            ),
                                          ),
                                          Text(
                                            '${hotel.city}, ${hotel.country}',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 10,
                                            ),
                                          ),
                                          SizedBox(height: 6),
                                          Container(
                                            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                            decoration: BoxDecoration(
                                              color: transaction['booking_status']=='canceled' ? Colors.red: Color(0xFFD1FAE5),
                                              borderRadius:
                                              BorderRadius.circular(4),
                                            ),
                                            child: Text(
                                              transaction['booking_status'] ?? 'ongoing',
                                              style: TextStyle(
                                                fontSize: 10,
                                                color: transaction['booking_status']=='canceled' ? Colors.white: Colors.green,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10),
                                // garis pemisah
                                Container(
                                  height: 1,
                                  color: Colors.grey[300],
                                ),
                                SizedBox(height: 10),
                                // tombol
                                if (transaction['booking_status']=='ongoing')
                                  Row(
                                    children: [
                                      //TOMBOL CANCEL BOOKING
                                      Expanded(
                                        child: ElevatedButton(
                                          onPressed: () async {
                                            // konfirmasi pembatalan booking
                                            final confirm = await showDialog<bool>(
                                              context: context,
                                              builder: (dialogContext) {
                                                return AlertDialog(
                                                  title: Text('Cancel Booking'),
                                                  content: Text(
                                                    'Are you sure you want to cancel this booking?',
                                                  ),
                                                  actions: [
                                                    TextButton(
                                                      onPressed: () {
                                                        Navigator.pop(dialogContext, false);
                                                      },
                                                      child: Text('No'),
                                                    ),
                                                    TextButton(
                                                      onPressed: () {
                                                        Navigator.pop(dialogContext, true);
                                                      },
                                                      child: Text(
                                                        'Yes, Cancel',
                                                        style: TextStyle(color: Colors.red),
                                                      ),
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                            if (confirm == true) {
                                              await cancelBooking(
                                                (transaction['id'] as num).toInt(),
                                              );
                                            }
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.white,
                                            side: BorderSide(
                                              color: Colors.green,
                                              width: 1.5,
                                            ),
                                          ),
                                          child: Text(
                                            'Cancel Booking',
                                            style: TextStyle(
                                              color: Colors.green,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 10),
                                      //TOMBOL VIEW TICKET
                                      Expanded(
                                        child: ElevatedButton(
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => TicketPage(
                                                  hotel: hotel,
                                                  guest: (transaction['guest'] as num).toInt(),
                                                  room: (transaction['room'] as num).toInt(),
                                                  totalPrice: (transaction['total_price'] as num).toInt(),
                                                  payMet: transaction['payment_method'],
                                                  checkInDate: DateTime.parse(transaction['check_in']),
                                                  checkOutDate: DateTime.parse(transaction['check_out']),
                                                  transactionId: (transaction['id'] as num).toInt(),
                                                ),
                                              ),
                                            );
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Color(0xFF10B981),
                                            side: BorderSide(
                                              color: Colors.green,
                                              width: 1.5,
                                            ),
                                          ),
                                          child: Text(
                                            'View Ticket',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                              ],
                            ),
                          );
                        }),
                        SizedBox(height: 20),
                      ],
                    ),
                  )
                ],
              )
          ),
        ),
      ),
      //tempat navigasi
      bottomNavigationBar: BottomNavigation(currentIndex: 2),
      // bottomNavigationBar: BottomNavigationBar(
      //   currentIndex: 2,
      //   type: BottomNavigationBarType.fixed,
      //   backgroundColor: Colors.white,
      //   selectedItemColor: Color(0xFF10B981),
      //   unselectedItemColor: Colors.grey,
      //   onTap: (index) {
      //     if(index == 0){
      //       Navigator.push(context, MaterialPageRoute(builder: (context) => const HomePage()),
      //       );
      //     } else if (index == 1){
      //       Navigator.push(context, MaterialPageRoute(builder: (context) => const SearchPage()),
      //       );
      //     } else if (index == 2){
      //       Navigator.push(context, MaterialPageRoute(builder: (context) => const BookingPage()),
      //       );
      //     } else if (index == 3){
      //       Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfilePage()),
      //       );
      //     }
      //   },
      //   items: [
      //     BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Home'),
      //     BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
      //     BottomNavigationBarItem(icon: Icon(Icons.receipt_long_outlined), label: 'Booking'),
      //     BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
      //   ],
      // ),
    );
  }
}