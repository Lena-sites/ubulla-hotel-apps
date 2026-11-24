import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:hotelapps/models/hotelgallery.dart';

class HotelGalleryService {
  final supabase = Supabase.instance.client;

  Future<List<HotelGallery>> getHotelGallery(int hotelId) async {
    final response = await supabase
        .from('hotel_gallery')
        .select()
        .eq('hotel_id', hotelId)
        .order('id', ascending: true);

    return response.map<HotelGallery>((photo) {
      return HotelGallery.fromJson(photo);
    }).toList();
  }
}
