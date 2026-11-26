import 'package:flutter/material.dart';
import 'package:hotelapps/ui/widgets/navigation.dart';
import 'package:hotelapps/services/hotel_service.dart';
import 'package:hotelapps/models/hotels.dart';
import 'package:hotelapps/ui/widgets/pricefilterpopup.dart';
import 'package:hotelapps/services/favorite_service.dart';
import 'package:hotelapps/ui/screens/favorite.dart';
import 'package:hotelapps/ui/screens/detail.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String notifText='';
  bool showNotif=false;
  bool selected=false;
  String searchQuery='';
  String selectedCategory = 'All'; //default tampilin all hotel

  final HotelService hotelService = HotelService();
  List<Hotels> hotels = [];
  bool isLoading = true;

  final FavoriteService favoriteService = FavoriteService();

  final searchController = TextEditingController();

  @override
  void initState(){
    super.initState();
    daftarHotel();
    loadBookmarkedHotels();
  }

  Future<void> daftarHotel() async {
    try{
      final result = await hotelService.getHotels(
        latitude: 0,
        longitude: 0,
      );

      if (mounted){
        setState(() {
          hotels = result;
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  // Mengambil daftar ID hotel yang sudah di Favorite
  Future<void> loadBookmarkedHotels() async {
    try {
      final result = await favoriteService.getFavorites();

      if (!mounted) return;

      setState(() {
        bookmarkedHotels = result.map((hotel) => hotel.id).toSet();
      });
    } catch (e) {
      debugPrint('Gagal mengambil Favorite: $e');
    }
  }

  // Menambahkan atau menghapus hotel dari Favorite
  Future<void> toggleFavorite(Hotels hotel) async {
    final isBookmarked = bookmarkedHotels.contains(hotel.id);

    try {
      if (isBookmarked) {
        await favoriteService.removeFavorite(hotel.id);
      } else {
        await favoriteService.addFavorite(hotel.id);
      }

      if (!mounted) return;

      setState(() {
        if (isBookmarked) {
          bookmarkedHotels.remove(hotel.id);
        } else {
          bookmarkedHotels.add(hotel.id);
        }
      });

    } catch (e) {
      debugPrint('Error toggleFavorite: $e');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal memperbarui Favorite')),
      );
    }
  }

  //BUAT APA INI? HMM
  Set<int> bookmarkedHotels = {};

  List<Hotels> get filteredHotels{
    final cari = searchQuery.trim().toLowerCase();

    // Filter berdasarkan pencarian
    return hotels.where((h){
      final cocokSearch =
        h.name.toLowerCase().contains(cari) ||
        h.city.toLowerCase().contains(cari) ||
        h.country.toLowerCase().contains(cari);

      // Filter berdasarkan kategori
      final cocokKategori = selectedCategory == 'All' || h.category.toLowerCase()==selectedCategory.toLowerCase();

      final cocokHarga = selectedPrice == null || kategoriHarga(h.pricePerNight) == selectedPrice;

      return cocokSearch && cocokKategori && cocokHarga;

    }).toList();
  }

  //8000 jadi 8.000 ada titiknya
  String formatRupiah(int harga) {
    return harga.toString().replaceAllMapped(
      RegExp(r'\B(?=(\d{3})+(?!\d))'),
          (match) => '.',
    );
  }

  //INI BAGIAN BUAT TAMPILIN POPUP CHECK BOX FILTER HARGA
  //kategori harga yang dipilih (null = semua harga)
  String? selectedPrice;
  //mengatur posisi popup
  final LayerLink filterLayerLink = LayerLink();
  //menyimpan popup filter
  OverlayEntry? countryFilterOverlay;

  String kategoriHarga(int harga) {
    if (harga < 500000) return '< Rp 500.000';
    if (harga <= 1500000) return 'Rp 500.000 - 1.500.000';
    return '> Rp 1.500.000';
  }

  @override
  Widget build(BuildContext context) {

    // mengambil ukuran layar
    final screenWidth = MediaQuery.of(context).size.width;
    //jika lebar >600 dianggap layarnya lebar/besar
    final isLargeScreen = screenWidth > 600;

    final shownHotels = filteredHotels;

    //dark mode atau light mode
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF121212) : Colors.grey[200];
    final cardColor = Theme.of(context).cardColor;
    final placeholderColor = isDark ? const Color(0xFF333333) : Colors.grey[300];
    final textColor = Theme.of(context).colorScheme.onSurface;
    final searchBorderColor = isDark ? Colors.white54 : Colors.black;

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
            Spacer(),
            IconButton(
              icon: Icon(Icons.bookmark_outline),
              onPressed: () async {
                await Navigator.push(context, MaterialPageRoute(builder: (context) => const FavoritePage(),),);

                // Perbarui status bookmark setelah kembali dari Favorite
                await loadBookmarkedHotels();
              },
            ),
          ],
        ),
        automaticallyImplyLeading: false, //matiin tanda panah back otomatis
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                SizedBox(height: 15),
                Padding(
                  padding: EdgeInsets.only(left: 15,right: 15),
                  child: TextFormField(
                    controller: searchController,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.search,
                    onChanged: (value){
                      setState(() {
                        searchQuery = value;
                      });
                    },
                    decoration: InputDecoration(
                        fillColor: cardColor,
                        filled: true,
                        hintText: 'Search',
                        prefixIcon: Icon(Icons.search_outlined),
                        suffixIcon: CompositedTransformTarget(
                          link: filterLayerLink,
                          child: IconButton(
                              onPressed: (){
                                //memanggil function buka halaman filter
                                bukaFilterPrice();
                              },
                              icon: Icon(Icons.tune)
                          ),
                        ),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        //kondisi klo fieldnya ditekan, bordernya tetap warna hitam
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: searchBorderColor),
                        ),
                        floatingLabelStyle: TextStyle(color: Colors.black) //warna labelTextnya saat floating biar tetap hitam
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Expanded(
                  child: SingleChildScrollView(
                    //basee container
                    child: Container(
                      padding: EdgeInsets.all(20),
                      color: bgColor,
                      child: Column(
                        children: [
                          //bagian tombol2 filtering
                          //Row ini bisa scroll ke samping
                          SizedBox(height: 20,),
                          SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child:Row(
                                children: [
                                  SizedBox(width: 20,),
                                  //ALL
                                  ElevatedButton(
                                    onPressed: () {
                                      setState(() {
                                        selectedCategory = 'All';
                                      });
                                    },
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: selectedCategory == 'All' ? Color(0xFF10B981) : cardColor,
                                      side: BorderSide(color: Colors.green, width: 1.5)
                                    ),
                                    child: Text('All', style: TextStyle(
                                      color: selectedCategory == 'All'? Colors.white: Colors.green,
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
                                        selectedCategory = 'Recommended';
                                      });
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: selectedCategory == 'Recommended'
                                          ? Color(0xFF10B981)
                                          : cardColor,
                                      side: BorderSide(
                                        color: Colors.green, // Warna border hijau untuk kedua kondisi
                                        width: 1.5,
                                      ),
                                    ),
                                    child: Text('Recommended', style: TextStyle(
                                      color: selectedCategory == 'Recommended'? Colors.white: Colors.green,
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
                                        selectedCategory = 'Popular';
                                      });
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: selectedCategory == 'Popular'
                                          ? const Color(0xFF10B981)
                                          : cardColor,
                                      side: BorderSide(
                                        color: Colors.green, // Warna border hijau untuk kedua kondisi
                                        width: 1.5,
                                      ),
                                    ),
                                    child: Text('Popular', style: TextStyle(
                                      color: selectedCategory == 'Popular'? Colors.white: Colors.green,
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
                                        selectedCategory = 'Trending';
                                      });
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: selectedCategory == 'Trending'
                                          ? const Color(0xFF10B981)
                                          : cardColor,
                                      side: BorderSide(
                                        color: Colors.green, // Warna border hijau untuk kedua kondisi
                                        width: 1.5,
                                      ),
                                    ),
                                    child: Text('Trending', style: TextStyle(
                                      color: selectedCategory == 'Trending'? Colors.white: Colors.green,
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
                                        selectedCategory = 'New';
                                      });
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: selectedCategory == 'New'
                                          ? const Color(0xFF10B981)
                                          : cardColor,
                                      side: BorderSide(
                                        color: Colors.green, // Warna border hijau untuk kedua kondisi
                                        width: 1.5,
                                      ),
                                    ),
                                    child: Text('New', style: TextStyle(
                                      color: selectedCategory == 'New'? Colors.white: Colors.green,
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
                                  '$selectedCategory (${shownHotels.length})', //tampilkan total data hotel
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 5,),
                          //list hotel
                          if (isLoading)
                            Center(
                              child: Padding(
                                padding: EdgeInsets.all(30),
                                child: CircularProgressIndicator(),
                              ),
                            )
                          else if (shownHotels.isEmpty)
                            Padding(
                              padding: EdgeInsets.all(30),
                              child: Text(
                                searchQuery.trim().isEmpty
                                    ? 'Belum ada hotel tersedia.'
                                    : 'Pencarian "$searchQuery" tidak ditemukan.',
                              ),
                            )
                          else
                            ListView.separated(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: shownHotels.length > 10 ? 10 : shownHotels.length,
                              separatorBuilder: (context, index) => SizedBox(height: 12),
                              itemBuilder: (context, index){
                                final hotel = shownHotels[index];

                                //fotooo hotelnya di acak
                                // final gambar = 'assets/images/hotel${(index % 6) + 5}.jpg';
                                final isBookmarked = bookmarkedHotels.contains(hotel.id);

                                return GestureDetector(
                                  onTap: (){
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => DetailPage(hotel: hotel)));
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                        color: cardColor,
                                        borderRadius: BorderRadius.circular(10)
                                    ),
                                    child: Row(
                                      children: [
                                        // FOTO HOTEL
                                        // FOTO HOTEL
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(8),
                                          child: hotel.imageUrl.isNotEmpty
                                              ? Image.network(
                                            hotel.imageUrl,
                                            width: 80,
                                            height: 80,
                                            fit: BoxFit.cover,
                                            loadingBuilder: (context, child, progress) {
                                              if (progress == null) return child;
                                              return const SizedBox(
                                                width: 80,
                                                height: 80,
                                                child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
                                              );
                                            },
                                            errorBuilder: (context, error, stackTrace) => Container(
                                              width: 80,
                                              height: 80,
                                              color: placeholderColor,
                                              child: const Icon(Icons.hotel, color: Colors.grey),
                                            ),
                                          )
                                              : Container(
                                            width: 80,
                                            height: 80,
                                            color: placeholderColor,
                                            child: Icon(Icons.hotel, color: Colors.grey),
                                          ),
                                        ),
                                        SizedBox(width: 10),
                                        //IFORMASI HOTEL
                                        Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(hotel.name,
                                                  maxLines: 1,
                                                  overflow: TextOverflow.ellipsis,
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 13,
                                                  ),
                                                ),
                                                Text(
                                                  '${hotel.city}, ${hotel.country}',
                                                  maxLines: 1,
                                                  overflow: TextOverflow.ellipsis,
                                                  style: TextStyle(fontSize: 10),
                                                ),
                                                SizedBox(height: 3),
                                                Text(hotel.pricePerNight > 0
                                                    ? 'Rp ${formatRupiah(hotel.pricePerNight)}/nigth'
                                                    : 'Harga belum tersedia',
                                                  style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold),
                                                )
                                              ],
                                            )
                                        ),
                                        SizedBox(width: 5),
                                        //BINTANG DAN BOOKMARK
                                        Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Row(
                                              children: [
                                                Icon(Icons.star, color: Colors.amber,size: 16),
                                                SizedBox(width: 2),
                                                Text(hotel.hotelStars?.toString() ?? '-', style: TextStyle(fontSize: 11))
                                              ],
                                            ),
                                          ],
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            toggleFavorite(hotel);
                                          },
                                          child: Icon(
                                            isBookmarked
                                                ? Icons.bookmark
                                                : Icons.bookmark_outline,
                                            color: isBookmarked
                                                ? const Color(0xFF10B981)
                                                : textColor,
                                            size: 20,
                                          ),
                                        ),
                                        SizedBox(width: 5)
                                      ],
                                    ),
                                  ),
                                );
                              },
                            )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
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
      //tempat navigasi
      bottomNavigationBar: BottomNavigation(currentIndex: 1),
    );
  }


  //FUNCTION UNTUK BUKA POP UP FILTER HARGA
  void bukaFilterPrice() {
    if (countryFilterOverlay != null) {
      tutupFilterPrice();
      return;
    }

    countryFilterOverlay = OverlayEntry(
      builder: (context) {
        return Stack(
          children: [
            // Menutup popup ketika area luar ditekan
            Positioned.fill(
              child: GestureDetector(
                onTap: tutupFilterPrice,
                child: Container(color: Colors.transparent),
              ),
            ),

            // Posisi popup mengikuti ikon filter
            CompositedTransformFollower(
              link: filterLayerLink,
              showWhenUnlinked: false,
              targetAnchor: Alignment.bottomRight,
              followerAnchor: Alignment.topRight,
              offset: Offset(0, 8),

              child: PriceFilterPopup(
                selectedPrice: selectedPrice,
                onApply: (value) {
                  setState(() => selectedPrice = value);
                  tutupFilterPrice();
                },
              ),
            ),
          ],
        );
      },
    );

    Overlay.of(context).insert(countryFilterOverlay!);
  }

  //FUNCTION BUAT TUTUP POP UP FILTER NEGARA
  void tutupFilterPrice() {
    countryFilterOverlay?.remove();
    countryFilterOverlay = null;
  }
}