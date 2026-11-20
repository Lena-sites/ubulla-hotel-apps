import 'package:supabase_flutter/supabase_flutter.dart';

class SupportService {
  final supabase = Supabase.instance.client;

  Future<void> sendSupportEmail({
    required String subject,
    required String category,
    required String message,
  }) async {
    final user = supabase.auth.currentUser;

    if (user == null || user.email == null) {
      throw Exception('Please login first.');
    }

    final response = await supabase.functions.invoke(
      'send-support-email',
      body: {
        'subject': subject,
        'category': category,
        'message': message,
      },
    );

    if (response.status != 200) {
      throw Exception(
        response.data?['error'] ?? 'Failed to send support email.',
      );
    }
  }
}
