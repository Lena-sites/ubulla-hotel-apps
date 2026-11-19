import 'package:supabase_flutter/supabase_flutter.dart';

class UserService {
  final supabase = Supabase.instance.client;

  String getUsername(){
    final user = supabase.auth.currentUser;
    final metadata= user?.userMetadata ?? {};

    //username itu yg login manual, name ambil nama yg login pake google
    return metadata['username'] ??
        metadata['name'] ??
        user?.email?.split('@').first ?? 'Guest';
  }
}