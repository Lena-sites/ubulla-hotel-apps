import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:hotelapps/models/paymentuser.dart';

class PaymentUserService {
  final supabase = Supabase.instance.client;

  // Mengambil semua kartu milik user yang sedang login
  Future<List<PaymentUser>> getPayments() async {
    final user = supabase.auth.currentUser;

    if (user == null) {
      return [];
    }

    final response = await supabase
        .from('payment_user')
        .select()
        .eq('user_id', user.id)
        .order('created_at', ascending: false);

    return response.map<PaymentUser>((payment) {
      return PaymentUser.fromJson(payment);
    }).toList();
  }

  // Menambahkan kartu baru
  Future<void> addPayment({
    required String cardholderName,
    required String cardNumber,
    required String cardType,
    required String expiryDate,
  }) async {
    final user = supabase.auth.currentUser!;

    // Menghapus spasi atau karakter selain angka
    final normalizedCardNumber =
    cardNumber.replaceAll(RegExp(r'[^0-9]'), '');

    // Memastikan nomor kartu terdiri dari 16 digit
    if (!RegExp(r'^[0-9]{16}$').hasMatch(normalizedCardNumber)) {
      throw Exception('Card number must contain 16 digits.');
    }

    await supabase.from('payment_user').insert({
      'user_id': user.id,
      'cardholder_name': cardholderName,
      'card_number': normalizedCardNumber,
      'card_last4': normalizedCardNumber.substring(12),
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

  // Mengatur kartu sebagai kartu utama
  Future<void> setDefaultPayment(int paymentId) async {
    final user = supabase.auth.currentUser!;

    // Menghapus status default dari semua kartu user
    await supabase
        .from('payment_user')
        .update({'is_default': false})
        .eq('user_id', user.id);

    // Menetapkan kartu yang dipilih sebagai default
    await supabase
        .from('payment_user')
        .update({'is_default': true})
        .eq('id', paymentId)
        .eq('user_id', user.id);
  }
}