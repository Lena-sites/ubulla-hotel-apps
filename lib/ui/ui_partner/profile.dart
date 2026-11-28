import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PartnerProfilePage extends StatefulWidget {
  const PartnerProfilePage({super.key});

  @override
  State<PartnerProfilePage> createState() => _PartnerProfilePageState();
}

class _PartnerProfilePageState extends State<PartnerProfilePage> {
  final supabase = Supabase.instance.client;
  final _nameController = TextEditingController();

  static const Color primaryGreen = Color(0xFF10B981);

  String email = '';
  bool isLoading = true;
  bool isSaving = false;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _loadProfile() async {
    try {
      final user = supabase.auth.currentUser;

      if (user == null) return;

      email = user.email ?? '';

      final response = await supabase
          .from('profiles')
          .select('name')
          .eq('id', user.id)
          .maybeSingle();

      _nameController.text =
          response?['name'] ?? user.userMetadata?['name'] ?? '';
    } catch (e) {
      _showMessage('Failed to load profile: $e', isError: true);
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Future<void> _saveProfile() async {
    final user = supabase.auth.currentUser;
    final name = _nameController.text.trim();

    if (user == null) return;

    if (name.isEmpty) {
      _showMessage('Name cannot be empty.', isError: true);
      return;
    }

    setState(() {
      isSaving = true;
    });

    try {
      await supabase
          .from('profiles')
          .update({'name': name})
          .eq('id', user.id);

      await supabase.auth.updateUser(
        UserAttributes(
          data: {'name': name},
        ),
      );

      if (!mounted) return;

      _showMessage('Profile updated successfully!');
    } catch (e) {
      if (!mounted) return;
      _showMessage('Failed to update profile: $e', isError: true);
    } finally {
      if (mounted) {
        setState(() {
          isSaving = false;
        });
      }
    }
  }

  Future<void> _changePassword() async {
    final passwordController = TextEditingController();
    final confirmController = TextEditingController();

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Change Password'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'New Password',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 14),
              TextField(
                controller: confirmController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Confirm New Password',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryGreen,
                foregroundColor: Colors.white,
              ),
              onPressed: () => Navigator.pop(dialogContext, true),
              child: const Text('Update'),
            ),
          ],
        );
      },
    );

    if (confirmed != true) {
      passwordController.dispose();
      confirmController.dispose();
      return;
    }

    final password = passwordController.text;
    final confirmPassword = confirmController.text;

    passwordController.dispose();
    confirmController.dispose();

    if (password != confirmPassword) {
      _showMessage('Passwords do not match.', isError: true);
      return;
    }

    try {
      await supabase.auth.updateUser(
        UserAttributes(password: password),
      );

      if (!mounted) return;
      _showMessage('Password updated successfully!');
    } catch (e) {
      if (!mounted) return;
      _showMessage('Failed to update password: $e', isError: true);
    }
  }

  void _showMessage(String message, {bool isError = false}) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : primaryGreen,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9F8),
      appBar: AppBar(
        title: const Text(
          'My Profile',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF1F2937),
        elevation: 0,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [primaryGreen, Color(0xFF047857)],
                ),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 35,
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.person_rounded,
                      size: 38,
                      color: primaryGreen,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    _nameController.text.isEmpty
                        ? 'Partner Account'
                        : _nameController.text,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    email,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),

            const Text(
              'Personal Information',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1F2937),
              ),
            ),
            const SizedBox(height: 16),

            const Text(
              'Full Name',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                hintText: 'Enter your full name',
                prefixIcon: const Icon(Icons.person_outline),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 18),

            const Text(
              'Email Address',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: TextEditingController(text: email),
              readOnly: true,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.email_outlined),
                filled: true,
                fillColor: Colors.grey.shade100,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 22),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: isSaving ? null : _saveProfile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryGreen,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: isSaving
                    ? const CircularProgressIndicator(
                  color: Colors.white,
                )
                    : const Text(
                  'Save Changes',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),

            const Text(
              'Security',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1F2937),
              ),
            ),
            const SizedBox(height: 14),

            Card(
              color: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              child: ListTile(
                leading: const Icon(
                  Icons.lock_outline_rounded,
                  color: primaryGreen,
                ),
                title: const Text(
                  'Change Password',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                subtitle: const Text(
                  'Update your account password.',
                ),
                trailing: const Icon(Icons.chevron_right_rounded),
                onTap: _changePassword,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
