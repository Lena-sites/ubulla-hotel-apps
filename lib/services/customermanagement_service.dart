import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:hotelapps/models/customers.dart';

class CustomerManagementService {
  final supabase = Supabase.instance.client;

  // Mengambil seluruh data customer
  Future<List<Customers>> getAllCustomers() async {
    final response = await supabase
        .from('profiles')
        .select()
        .eq('role', 'customer')
        .order('created_at', ascending: false);

    return (response as List)
        .map((item) => Customers.fromJson(item))
        .toList();
  }

  Future<bool> getCustomerStatus(String customerId) async {
    final response = await supabase.functions.invoke(
      'manage-customer-account',
      body: {
        'customerId': customerId,
        'action': 'status',
      },
    );

    if (response.status != 200) {
      throw Exception(
        response.data?['error'] ?? 'Failed to get customer status',
      );
    }

    return response.data['isActive'] as bool;
  }

  //deactivate → menonaktifkan akun
  //reactivate → mengaktifkan kembali akun
  Future<void> manageCustomerAccount({
    required String customerId,
    required String action,
  }) async {
    final response = await supabase.functions.invoke(
      'manage-customer-account',
      body: {
        'customerId': customerId,
        'action': action,
      },
    );


    if (response.status != 200) {
      throw Exception(
        response.data?['error'] ?? 'Failed to manage customer account',
      );
    }
  }
}