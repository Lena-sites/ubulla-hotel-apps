import 'package:supabase_flutter/supabase_flutter.dart';

//MENGELOLA AKUN PENGGUNA
class ProfileService {
  final supabase = Supabase.instance.client;

  //edit username
  Future<void> updateUsername(String username) async{
    await supabase.auth.updateUser(
      UserAttributes(
        data: {
          'username': username,
        }
      )
    );
  }

  //edit email
  Future<void> updateEmail(String email) async{
    await supabase.auth.updateUser(
        UserAttributes(
            email: email
        )
    );
  }

  //edit password
  Future<void> updatePassword(String password) async{
    await supabase.auth.updateUser(
        UserAttributes(
            password: password
        )
    );
  }
}

// MENGELOLA METODE PEMBAYARAN JIKA MENGGUNAKAN CARD
class PaymentUserService {
  final supabase = Supabase.instance.client;

  // Mengambil daftar kartu milik pengguna
  Future<List<Map<String, dynamic>>> getPayments() async {
    final user = supabase.auth.currentUser!;

    final response = await supabase
        .from('payment_user')
        .select()
        .eq('user_id', user.id)
        .order('created_at', ascending: false);

    return List<Map<String, dynamic>>.from(response);
  }

  // Menambahkan kartu baru
  Future<void> addPayment({
    required String cardholderName,
    required String cardLast4,
    required String cardType,
    required String expiryDate,
  }) async {
    final user = supabase.auth.currentUser!;

    await supabase.from('payment_user').insert({
      'user_id': user.id,
      'cardholder_name': cardholderName,
      'card_last4': cardLast4,
      'card_type': cardType,
      'expiry_date': expiryDate,
    });
  }

  // Menghapus kartu
  Future<void> deletePayment(int paymentId) async {
    final user = supabase.auth.currentUser!;

    await supabase
        .from('payment_user')
        .delete()
        .eq('id', paymentId)
        .eq('user_id', user.id);
  }

  // Mengatur kartu utama
  Future<void> setDefaultPayment(int paymentId) async {
    final user = supabase.auth.currentUser!;

    await supabase
        .from('payment_user')
        .update({'is_default': false})
        .eq('user_id', user.id);

    await supabase
        .from('payment_user')
        .update({'is_default': true})
        .eq('id', paymentId)
        .eq('user_id', user.id);
  }
}