import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:hotelapps/models/hotelrooms.dart';

class HotelRoomService {
  final supabase = Supabase.instance.client;

  Future<List<HotelRooms>> getHotelRooms(int hotelId) async {
    final response = await supabase
        .from('hotel_rooms')
        .select('*, hotel_prices(*)')
        .eq('hotel_id', hotelId);

    return response.map<HotelRooms>((room) {
      return HotelRooms.fromJson(room);
    }).toList();
  }
}
