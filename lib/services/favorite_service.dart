import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:hotelapps/models/hotels.dart';

class FavoriteService {
  final supabase = Supabase.instance.client;

  //mengambil daftar hotel favorit milik user

  Future<List<Hotels>> getFavorites() async {
    final user = supabase.auth.currentUser!;

    final response = await supabase.from('favorites').select(
      'hotels(*, hotel_rooms(*, hotel_prices(*)), hotel_categories(category_name))',
    ).eq('user_id', user.id);

    return response.map<Hotels>((favorite) {
      return Hotels.fromJson(favorite['hotels']);
    }).toList();
  }


  //menambahkan hotel ke favorite
  Future<void> addFavorite(String hotelId) async{
    final user = supabase.auth.currentUser!;

    await supabase.from('favorites').insert({
      'user_id': user.id,
      'hotel_id': int.parse(hotelId),
    });
  }

  //Menghapus hotel dari Favorite
  Future<void> removeFavorite(String hotelId) async{
    final user = supabase.auth.currentUser!;

    await supabase.from('favorites').delete().eq('user_id', user.id).eq('hotel_id', int.parse(hotelId));
  }
}