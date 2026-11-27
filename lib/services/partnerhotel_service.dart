import 'package:hotelapps/models/hotels.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PartnerHotelService {
  final supabase = Supabase.instance.client;

  // Mengambil hotel milik Partner yang sedang login
  Future<List<Hotels>> getPartnerHotels() async {
    final user = supabase.auth.currentUser;

    if (user == null) {
      throw Exception('User belum login');
    }

    final response = await supabase
        .from('hotels')
        .select('*, hotel_rooms(*, hotel_prices(*)), hotel_categories(category_name), owner:profiles!hotels_partner_id_fkey(name)')
        .eq('partner_id', user.id);

    return response.map<Hotels>((hotel) {
      return Hotels.fromJson(hotel);
    }).toList();
  }

  // Menambahkan hotel baru milik Partner
  // Menambahkan hotel baru milik Partner
  Future<void> addPartnerHotel({
    required String name,
    required String address,
    required String city,
    required String country,
    required double latitude,
    required double longitude,
    required int hotelStars,
    required String description,
    required String imageUrl,
    required List<String> facilities,
    required List<Map<String, dynamic>> rooms,
  }) async {
    final user = supabase.auth.currentUser;

    if (user == null) {
      throw Exception('User belum login');
    }

    // Menentukan kategori hotel secara otomatis
    final categoryName = hotelStars == 5 ? 'Recommended' : 'New';

    final category = await supabase
        .from('hotel_categories')
        .select('id')
        .eq('category_name', categoryName)
        .single();

    // Menyimpan data hotel
    final hotel = await supabase
        .from('hotels')
        .insert({
      'name': name,
      'address': address,
      'city': city,
      'country': country,
      'latitude': latitude,
      'longitude': longitude,
      'hotel_stars': hotelStars,
      'category_id': category['id'],
      'image_url': imageUrl,
      'details': description,
      'facilities': facilities,
      'partner_id': user.id,
      'status': 'Active',
      'geoapify_place_id': null,
    })
        .select('id')
        .single();

    final hotelId = hotel['id'];

    // Menyimpan 3 tipe kamar beserta harganya
    for (final room in rooms) {
      final roomData = await supabase
          .from('hotel_rooms')
          .insert({
        'hotel_id': hotelId,
        'room_type': room['room_type'],
        'total_rooms': room['total_rooms'],
      })
          .select('id')
          .single();

      await supabase.from('hotel_prices').insert({
        'room_id': roomData['id'],
        'price_per_night': room['price_per_night'],
        'currency': 'IDR',
      });
    }
  }


  // Memperbarui hotel milik Partner
  Future<void> updatePartnerHotel({
    required int hotelId,
    required String name,
    required String address,
    required String city,
    required String country,
    required double latitude,
    required double longitude,
    required int hotelStars,
    required String description,
    required String imageUrl,
    required List<String> facilities,
    required List<Map<String, dynamic>> rooms,
  }) async {
    final user = supabase.auth.currentUser;

    if (user == null) {
      throw Exception('User belum login');
    }

    // Menentukan kategori berdasarkan jumlah bintang
    final categoryName = hotelStars == 5 ? 'Recommended' : 'New';

    final category = await supabase
        .from('hotel_categories')
        .select('id')
        .eq('category_name', categoryName)
        .single();

    // Memperbarui informasi hotel
    await supabase
        .from('hotels')
        .update({
      'name': name,
      'address': address,
      'city': city,
      'country': country,
      'latitude': latitude,
      'longitude': longitude,
      'hotel_stars': hotelStars,
      'category_id': category['id'],
      'image_url': imageUrl,
      'details': description,
      'facilities': facilities,
    })
        .eq('id', hotelId)
        .eq('partner_id', user.id);

    // Memperbarui jumlah kamar dan harga
    for (final room in rooms) {
      final roomData = await supabase
          .from('hotel_rooms')
          .select('id')
          .eq('hotel_id', hotelId)
          .eq('room_type', room['room_type'])
          .single();

      final roomId = roomData['id'];

      await supabase
          .from('hotel_rooms')
          .update({
        'total_rooms': room['total_rooms'],
      })
          .eq('id', roomId);

      await supabase
          .from('hotel_prices')
          .update({
        'price_per_night': room['price_per_night'],
        'currency': 'IDR',
      })
          .eq('room_id', roomId);
    }
  }

}