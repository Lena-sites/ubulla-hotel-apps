
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:hotelapps/models/paymentmethods.dart';

class PaymentMethodService {
  final SupabaseClient supabase = Supabase.instance.client;

  // Mengambil semua metode pembayaran yang aktif
  Future<List<PaymentMethods>> getPaymentMethods() async {
    final response = await supabase
        .from('payment_methods')
        .select()
        .eq('is_active', true)
        .order('id');

    return response
        .map((data) => PaymentMethods.fromJson(data))
        .toList();
  }
}
