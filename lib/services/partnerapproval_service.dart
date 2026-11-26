import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:hotelapps/models/partnerapplications.dart';

class PartnerApprovalService {
  final supabase = Supabase.instance.client;

  // Get all partner applications
  Future<List<PartnerApplications>> getAllApplications() async {
    final response = await supabase
        .from('partner_applications')
        .select()
        .order('created_at', ascending: false);

    return (response as List)
        .map((item) => PartnerApplications.fromJson(item))
        .toList();
  }

  // Approve or reject an application
  Future<void> updateApplicationStatus({
    required String applicationId,
    required String status,
    String? adminNote,
  }) async {
    await supabase.rpc(
      'review_partner_application',
      params: {
        'p_application_id': applicationId,
        'p_status': status,
        'p_admin_note': adminNote,
      },
    );
  }


  Future<String> getCustomerEmail(String userId) async {
    final response = await supabase
        .from('profiles')
        .select('email')
        .eq('id', userId)
        .single();

    return response['email'];
  }

}
