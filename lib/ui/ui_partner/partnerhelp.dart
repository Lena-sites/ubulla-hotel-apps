import 'package:flutter/material.dart';
import 'package:hotelapps/services/help_service.dart';

class PartnerHelpPage extends StatefulWidget {
  const PartnerHelpPage({super.key});

  @override
  State<PartnerHelpPage> createState() => _PartnerHelpPageState();
}

class _PartnerHelpPageState extends State<PartnerHelpPage> {
  final SupportService supportService = SupportService();

  final TextEditingController subjectController = TextEditingController();
  final TextEditingController messageController = TextEditingController();

  String category = 'Hotel Management';
  bool isSending = false;

  final List<String> categories = [
    'Account',
    'Hotel Management',
    'Room & Pricing',
    'Reservation',
    'Other',
  ];

  Future<void> sendMessage() async {
    final subject = subjectController.text.trim();
    final message = messageController.text.trim();

    if (subject.isEmpty || message.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please complete all fields.'),
        ),
      );
      return;
    }

    setState(() => isSending = true);

    try {
      await supportService.sendSupportEmail(
        subject: subject,
        category: category,
        message: message,
      );

      if (!mounted) return;

      subjectController.clear();
      messageController.clear();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Your report has been sent successfully.'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to send report: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => isSending = false);
      }
    }
  }

  @override
  void dispose() {
    subjectController.dispose();
    messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Help & Support'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Report an Issue',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Having trouble managing your hotel? '
                  'Send us a report and our team will assist you.',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 24),

            const Text(
              'Subject',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: subjectController,
              decoration: const InputDecoration(
                hintText: 'Enter your issue subject',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),

            const Text(
              'Category',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: category,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
              items: categories.map((item) {
                return DropdownMenuItem(
                  value: item,
                  child: Text(item),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() => category = value);
                }
              },
            ),
            const SizedBox(height: 20),

            const Text(
              'Message',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: messageController,
              maxLines: 7,
              decoration: const InputDecoration(
                hintText: 'Describe your issue in detail...',
                border: OutlineInputBorder(),
                alignLabelWithHint: true,
              ),
            ),
            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: isSending ? null : sendMessage,
                child: isSending
                    ? const CircularProgressIndicator(
                  color: Colors.white,
                )
                    : const Text('Send Report'),
              ),
            ),
            const SizedBox(height: 16),
            const Center(
              child: Text(
                'Our support team will receive your report '
                    'and can reply to your registered email.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
