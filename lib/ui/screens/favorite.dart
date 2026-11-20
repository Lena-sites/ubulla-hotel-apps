import 'package:flutter/material.dart';
import 'package:hotelapps/models/hotels.dart';
import 'package:hotelapps/services/favorite_service.dart';
import 'package:hotelapps/ui/screens/detail.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({super.key});

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  final FavoriteService favoriteService = FavoriteService();

  List<Hotels> favoriteHotels = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadFavorites();
  }

  // Mengambil data Favorite dari Supabase
  Future<void> loadFavorites() async {
    try {
      final result = await favoriteService.getFavorites();

      if (!mounted) return;

      setState(() {
        favoriteHotels = result;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal mengambil Favorite: $e')),
      );
    }
  }

  // Menghapus hotel dari Favorite
  Future<void> removeFavorite(Hotels hotel) async {
    try {
      await favoriteService.removeFavorite(hotel.id);

      if (!mounted) return;

      setState(() {
        favoriteHotels.removeWhere((item) => item.id == hotel.id);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Hotel dihapus dari Favorite')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menghapus Favorite: $e')),
      );
    }
  }

  // Format harga Rupiah
  String formatRupiah(int harga) {
    return 'Rp ${harga.toString().replaceAllMapped(
      RegExp(r'\B(?=(\d{3})+(?!\d))'),
          (match) => '.',
    )}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Favorite'),
        centerTitle: false,
      ),

      body: isLoading
          ? Center(child: CircularProgressIndicator())

          : favoriteHotels.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.bookmark_border,
              size: 65,
              color: Colors.grey,
            ),
            SizedBox(height: 12),
            Text(
              'Belum ada hotel Favorite',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      )

          : ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: favoriteHotels.length,
        itemBuilder: (context, index) {
          final hotel = favoriteHotels[index];

          return GestureDetector(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => DetailPage(hotel: hotel)));
            },
            child: Card(
              margin: EdgeInsets.only(bottom: 12),
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Row(
                  children: [
                    // FOTO HOTEL
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.asset(
                        'assets/images/hotel1.jpg',
                        width: 110,
                        height: 120,
                        fit: BoxFit.cover,
                      ),
                    ),

                    SizedBox(width: 12),

                    // INFORMASI HOTEL
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            hotel.name,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),

                          SizedBox(height: 5),

                          Text(
                            '${hotel.city}, ${hotel.country}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                            ),
                          ),

                          SizedBox(height: 8),

                          Text(
                            formatRupiah(hotel.pricePerNight),
                            style: TextStyle(
                              color: Color(0xFF10B981),
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          if (hotel.hotelStars != null)
                            Row(
                              children: [
                                Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                  size: 16,
                                ),
                                SizedBox(width: 4),
                                Text('${hotel.hotelStars}'),
                              ],
                            ),
                        ],
                      ),
                    ),

                    // TOMBOL FAVORITE
                    IconButton(
                      icon: Icon(
                        Icons.bookmark,
                        color: Color(0xFF10B981),
                      ),
                      onPressed: () {
                        removeFavorite(hotel);
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
