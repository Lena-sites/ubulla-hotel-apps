
import 'package:supabase_flutter/supabase_flutter.dart';

class ReservationService {
  final supabase = Supabase.instance.client;

  Future<List<Map<String, dynamic>>> getPartnerReservations() async {
    final user = supabase.auth.currentUser;

    if (user == null) {
      throw Exception('Please login first.');
    }

    final hotels = await supabase
        .from('hotels')
        .select('id')
        .eq('partner_id', user.id);

    final hotelIds = hotels.map((hotel) => hotel['id']).toList();

    if (hotelIds.isEmpty) return [];

    final data = await supabase
        .from('transactions')
        .select('*, customer:profiles!transactions_profiles_fkey(name, email), room_info:hotel_rooms!transactions_room_id_fkey(room_type)')
        .inFilter('hotel_id', hotelIds)
        .order('created_at', ascending: false);

    return List<Map<String, dynamic>>.from(data);
  }
}
