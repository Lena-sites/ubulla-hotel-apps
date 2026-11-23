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
}
