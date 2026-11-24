import 'package:hotelapps/models/hotels.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HotelService {
  final supabase = Supabase.instance.client;

  //mengambil semua hotel
  Future<List<Hotels>> getHotels({
    required double latitude,
    required double longitude,
  })async {
    // Mengambil data hotel langsung dari tabel di Supabase

    final response = await supabase
        .from('hotels')
        .select('*, hotel_rooms(*, hotel_prices(*)), hotel_categories(category_name)');

    // debugPrint('Jumlah: ${response.length}');
    // final response = await supabase
    //     .from('hotels')
    //     .select('*, hotel_rooms(room_type, hotel_prices(price_per_night, currency)), hotel_categories(category_name)');
    // final response = await supabase
    //     .from('hotels')
    //     .select('*, hotel_prices(price_per_night, currency), hotel_categories(category_name)');

    //mengubah data JSON menjadi objek Hotels. jadi tinggal panggil aja misal hotel.category
    return response.map<Hotels>((hotel){
      return Hotels.fromJson(hotel);
    }).toList();
  }

  // function untuk mengambil detail hotel berdasarkan ID (mengambil satu hotel berdasarkan ID)
  Future<Hotels> getHotelById(int hotelId) async {
    final response = await supabase
        .from('hotels')
        .select('*, hotel_rooms(*, hotel_prices(*)), hotel_categories(category_name)')
        .eq('id', hotelId)
        .single();

    return Hotels.fromJson(response);
  }

  // Mengambil hotel yang memiliki 5 bintang
  Future<List<Hotels>> getFiveStarHotels() async {
    final response = await supabase
        .from('hotels')
        .select('*, hotel_rooms(*, hotel_prices(*)), hotel_categories(category_name)')
        .eq('hotel_stars', 5);

    return response.map<Hotels>((hotel) {
      return Hotels.fromJson(hotel);
    }).toList();
  }
}