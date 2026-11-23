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

  // Fungsi untuk mengurangi jumlah kamar setelah booking
  Future<void> reduceRoomStock(int roomId, int bookedRoom) async {
    // Mengambil data kamar saat ini
    final response = await supabase
        .from('hotel_rooms')
        .select('total_rooms')
        .eq('id', roomId)
        .single();

    // Mengambil jumlah kamar yang tersedia
    final currentRooms = (response['total_rooms'] as num).toInt();

    // Memastikan stok kamar mencukupi
    if (currentRooms < bookedRoom) {
      throw Exception('Jumlah kamar yang tersedia tidak mencukupi.');
    }

    // Mengurangi stok kamar
    await supabase
        .from('hotel_rooms')
        .update({
      'total_rooms': currentRooms - bookedRoom,
    })
        .eq('id', roomId);
  }
}
