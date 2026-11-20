import 'package:hotelapps/models/hotels.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HotelService {
  final supabase = Supabase.instance.client;

  Future<List<Hotels>> getHotels({
    required double latitude,
    required double longitude,
  })async {
    // Mengambil data hotel langsung dari tabel di Supabase
    final response = await supabase
        .from('hotels')
        .select('*, hotel_prices(price_per_night, currency), hotel_categories(category_name)');

    //mengubah data JSON menjadi objek Hotels. jadi tinggal panggil aja misal hotel.category
    return response.map<Hotels>((hotel){
      return Hotels.fromJson(hotel);
    }).toList();
  }
}