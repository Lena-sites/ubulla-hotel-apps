
import 'package:flutter/material.dart';
import 'package:hotelapps/services/help_service.dart';

class HelpPage extends StatefulWidget {
  const HelpPage({super.key});

  @override
  State<HelpPage> createState() => _HelpPageState();
}

class _HelpPageState extends State<HelpPage> {
  final supportService = SupportService();

  final subjectController = TextEditingController();
  final messageController = TextEditingController();

  String category = 'Booking';
  bool isSending = false;

  final categories = [
    'Booking',
    'Payment',
    'Account',
    'Hotel Information',
    'Other',
  ];

  @override
  void dispose() {
    subjectController.dispose();
    messageController.dispose();
    super.dispose();
  }

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
          content: Text('Your message has been sent successfully!'),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to send message: $e')),
      );
    } finally {
      if (mounted) {
        setState(() => isSending = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark =
        Theme.of(context).brightness == Brightness.dark;

    final textColor =
    isDark ? Colors.white : Colors.black87;

    final subTextColor =
    isDark ? Colors.white60 : Colors.black54;

    final fieldColor =
    isDark ? Colors.grey.shade900 : Colors.grey.shade100;

    return Scaffold(
      backgroundColor:
      isDark ? Colors.black : Colors.white,
      appBar: AppBar(
        title: const Text(
          'Help & Support',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor:
        isDark ? Colors.black : Colors.white,
        foregroundColor: textColor,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(
              Icons.support_agent,
              size: 48,
            ),

            const SizedBox(height: 16),

            Text(
              'How can we help?',
              style: TextStyle(
                fontSize: 23,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              'Have a question or an issue? Send us a message and our support team will get back to you via email.',
              style: TextStyle(color: subTextColor),
            ),

            const SizedBox(height: 28),

            Text(
              'Subject',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: textColor,
              ),
            ),

            const SizedBox(height: 8),

            TextField(
              controller: subjectController,
              decoration: InputDecoration(
                hintText: 'Enter your issue title',
                filled: true,
                fillColor: fieldColor,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 20),

            Text(
              'Category',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: textColor,
              ),
            ),

            const SizedBox(height: 8),

            DropdownButtonFormField<String>(
              value: category,
              decoration: InputDecoration(
                filled: true,
                fillColor: fieldColor,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
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

            Text(
              'Message',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: textColor,
              ),
            ),

            const SizedBox(height: 8),

            TextField(
              controller: messageController,
              maxLines: 6,
              decoration: InputDecoration(
                hintText: 'Describe your issue here...',
                filled: true,
                fillColor: fieldColor,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 28),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isSending ? null : sendMessage,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    vertical: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: isSending
                    ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
                    : const Text(
                  'Send Message',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            Center(
              child: Text(
                'Our support team will reply to your email.',
                style: TextStyle(
                  fontSize: 12,
                  color: subTextColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
