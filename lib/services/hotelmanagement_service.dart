import 'package:hotelapps/models/hotels.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HotelManagementService {
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
        .eq('id', hotelId)
        .select()
        .single();
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

  //fungsi update nama hotel
  Future<void> updateHotelName(int hotelId, String newName) async {
    await supabase
        .from('hotels')
        .update({'name': newName})
        .eq('id', hotelId);
  }

  //update alamat hotel
  Future<void> updateHotelAddress(int hotelId, String newAddress) async {
    await supabase
        .from('hotels')
        .update({'address': newAddress})
        .eq('id', hotelId);
  }

  //update nama city
  Future<void> updateHotelCity(int hotelId, String newCity) async {
    await supabase
        .from('hotels')
        .update({'city': newCity})
        .eq('id', hotelId);
  }

  Future<void> updateHotelCountry(int hotelId, String newCountry) async {
    await supabase
        .from('hotels')
        .update({'country': newCountry})
        .eq('id', hotelId);
  }

  Future<void> updateHotelCoordinates(
      int hotelId,
      double latitude,
      double longitude,
      ) async {
    await supabase
        .from('hotels')
        .update({
      'latitude': latitude,
      'longitude': longitude,
    })
        .eq('id', hotelId);
  }

  Future<void> updateHotelStars(int hotelId, int newStars) async {
    await supabase
        .from('hotels')
        .update({'hotel_stars': newStars})
        .eq('id', hotelId);
  }

  Future<void> updateHotelDescription(
      int hotelId,
      String newDescription,
      ) async {
    await supabase
        .from('hotels')
        .update({'details': newDescription})
        .eq('id', hotelId);
  }

  Future<void> updateHotelFacilities(
      int hotelId,
      List<String> newFacilities,
      ) async {
    await supabase
        .from('hotels')
        .update({'facilities': newFacilities})
        .eq('id', hotelId);
  }

  Future<void> updateAvailableRooms(
      int roomId,
      int newTotalRooms,
      ) async {
    await supabase
        .from('hotel_rooms')
        .update({'total_rooms': newTotalRooms})
        .eq('id', roomId);
  }

  // Menghapus hotel oleh Admin
  Future<void> deleteHotel(int hotelId) async {
    await supabase
        .from('hotels')
        .delete()
        .eq('id', hotelId);
  }

  // Mengecek apakah hotel memiliki riwayat transaksi
  Future<bool> hasTransactions(int hotelId) async {
    final result = await supabase.rpc(
      'hotel_has_transactions',
      params: {
        'p_hotel_id': hotelId,
      },
    );

    return result as bool;
  }

}