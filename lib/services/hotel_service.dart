import 'package:hotelapps/models/hotels.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HotelService {
  final supabase = Supabase.instance.client;

  Future<List<Hotels>> getHotels({
    required double latitude,
    required double longitude,
  })async {
    // Mengambil data hotel langsung dari tabel di Supabase
    final response = await supabase.from('hotels').select();

    //mengubah data JSON menjadi objek Hotels
    return response.map<Hotels>((hotel){
      return Hotels.fromJson(hotel);
    }).toList();
  }
}