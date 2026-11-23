import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:hotelapps/models/transaction.dart';

class TransactionService {
  final SupabaseClient supabase = Supabase.instance.client;

  Future<void> addTransaction(Transaction transaction) async {
    // Mengambil user yang sedang login
    final user = supabase.auth.currentUser;

    if (user == null) {
      throw Exception('User belum login.');
    }

    // Mengirim data transaksi ke Supabase
    await supabase
        .from('transactions')
        .insert(transaction.toJson(user.id));
  }

  // function untuk mengambil transaksi milik user yang sedang login
  Future<List<Map<String, dynamic>>> getTransactions() async {
    //auth.currentUser mengambil akun yang sedang login.
    final user = supabase.auth.currentUser;

    if (user == null) {
      throw Exception('User belum login.');
    }

    final response = await supabase
        .from('transactions')
        .select()
        .eq('user_id', user.id) //memastikan hanya transaksi milik pengguna tersebut yang diambil.
        .order('created_at', ascending: false); //.order('created_at', ascending: false) mengurutkan transaksi dari yang terbaru (jadi nnti di booking page, yg terbaru jd teratas)

    return List<Map<String, dynamic>>.from(response); //return mengembalikan daftar transaksi dari Supabase
  }

  // function untuk membatalkan booking
  Future<void> cancelBooking(int transactionId) async {
    final user = supabase.auth.currentUser;

    if (user == null) {
      throw Exception('User belum login.');
    }

    await supabase
        .from('transactions')
        .update({
      'booking_status': 'canceled',
    })
        .eq('id', transactionId) //hapus berdasarkan transcation id
        .eq('user_id', user.id);
  }
}
