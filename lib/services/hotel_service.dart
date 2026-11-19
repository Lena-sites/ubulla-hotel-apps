import 'package:supabase_flutter/supabase_flutter.dart';

class HotelService {
  final supabase = Supabase.instance.client;

  Future<List<dynamic>> getHotels({
    required double latitude,
    required double longitude,
  })async {
    final response = await supabase.functions.invoke(
      'get-hotels',
      body: {
        'latitude': latitude,
        'longitude': longitude,
      },
    );

    final data = response.data;

    return data['features'] ?? [];
  }
}