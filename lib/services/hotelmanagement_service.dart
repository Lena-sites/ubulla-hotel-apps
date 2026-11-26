import 'package:hotelapps/models/hotels.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AdminHotelManagementService {
  final supabase = Supabase.instance.client;

  // Mengambil semua hotel untuk Admin
  Future<List<Hotels>> getAllHotels() async {
    final response = await supabase
        .from('hotels')
        .select('*, hotel_rooms(*, hotel_prices(*)), hotel_categories(category_name), owner:profiles!hotels_partner_id_fkey(name)');

    return response.map<Hotels>((hotel) {
      return Hotels.fromJson(hotel);
    }).toList();
  }

  // Mengubah status hotel oleh Admin
  Future<void> updateHotelStatus(int hotelId, String newStatus) async {
    await supabase
        .from('hotels')
        .update({'status': newStatus})
        .eq('id', hotelId);
  }

  // Memproses pembatalan booking dan notifikasi refund
  Future<void> processHotelRefunds(int hotelId) async {
    final response = await supabase.functions.invoke(
      'process-hotel-refunds', //pemanggil Edge Function
      body: {
        'hotel_id': hotelId,
      },
    );

    if (response.status != 200) {
      throw Exception(
        'Gagal memproses refund: ${response.data}',
      );
    }
  }

  // Mengubah status hotel sekaligus memproses refund jika diperlukan
  Future<void> changeHotelStatus(int hotelId, String newStatus) async {
    // Simpan perubahan status hotel terlebih dahulu
    await updateHotelStatus(hotelId, newStatus);

    // Proses refund hanya jika hotel Non-active atau Suspend
    if (newStatus == 'Non-active' || newStatus == 'Suspend') {
      await processHotelRefunds(hotelId);
    }
  }
}