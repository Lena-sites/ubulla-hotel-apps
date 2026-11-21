import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
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

  //mengambil URL foto profil
  String getProfilePhotoUrl(){
    final user = supabase.auth.currentUser;
    final avatarUrl = user?.userMetadata?['avatar_url'] as String?;

    if (avatarUrl == null || avatarUrl.isEmpty){
      return 'assets/images/dummy.jpg';
    }
    return  avatarUrl;
  }

  //upload dan update foto profil
  Future<void> updateProfilePhoto(XFile image) async {
    final user = supabase.auth.currentUser;
    if (user == null) throw Exception('User belum login.');

    final bytes = await image.readAsBytes();
    final extension = image.name.split('.').last.toLowerCase();

    final contentType = switch (extension) {
      'png' => 'image/png',
      'webp' => 'image/webp',
      'heic' => 'image/heic',
      _ => 'image/jpeg',
    };

    final bucket = supabase.storage.from('profile-photos');

    // 1. Upload file baru dengan nama unik (cukup policy INSERT)
    final fileName = 'profile_${DateTime.now().millisecondsSinceEpoch}.$extension';
    final path = '${user.id}/$fileName';

    await bucket.uploadBinary(
      path,
      bytes,
      fileOptions: FileOptions(contentType: contentType),
    );

    // 2. Simpan URL baru ke metadata
    final imageUrl = bucket.getPublicUrl(path);
    await supabase.auth.updateUser(
      UserAttributes(data: {'avatar_url': imageUrl}),
    );

    // 3. Hapus semua file lain di folder user, sisakan yang baru
    final files = await bucket.list(path: user.id);
    final toRemove = files
        .where((f) => f.name != fileName && f.name != '.emptyFolderPlaceholder')
        .map((f) => '${user.id}/${f.name}')
        .toList();

    debugPrint('>>> FILE BARU: $fileName | AKAN DIHAPUS: $toRemove');

    if (toRemove.isNotEmpty) {
      await bucket.remove(toRemove);
    }
  }

  Future<void> deleteProfilePhoto() async {
    final user = supabase.auth.currentUser;
    if (user == null) throw Exception('User belum login.');

    final bucket = supabase.storage.from('profile-photos');

    // Ambil semua file di folder user, apa pun namanya
    final files = await bucket.list(path: user.id);
    final toRemove = files
        .where((f) => f.name != '.emptyFolderPlaceholder')
        .map((f) => '${user.id}/${f.name}')
        .toList();

    if (toRemove.isNotEmpty) {
      final result = await bucket.remove(toRemove);
      debugPrint('DELETED FILES: ${result.length}');
    }

    // Kosongkan avatar_url di metadata
    await supabase.auth.updateUser(
      UserAttributes(data: {'avatar_url': null}),
    );
  }
}