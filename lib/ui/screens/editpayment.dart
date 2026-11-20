import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:hotelapps/services/profile_service.dart';
import 'package:hotelapps/services/paymentuser_service.dart';


Future<bool?> showEditPaymentDialog(BuildContext context) async {
  final paymentService = PaymentUserService();

  return showDialog<bool>(
    context: context,
    builder: (dialogContext) {
      return _EditPaymentDialog(
        paymentService: paymentService,
      );
    },
  );
}

class _EditPaymentDialog extends StatefulWidget {
  final PaymentUserService paymentService;

  const _EditPaymentDialog({
    required this.paymentService,
  });

  @override
  State<_EditPaymentDialog> createState() => _EditPaymentDialogState();
}

class _EditPaymentDialogState extends State<_EditPaymentDialog> {
  final cardholderController = TextEditingController();
  final cardNumberController = TextEditingController();
  final expiryController = TextEditingController();

  List<Map<String, dynamic>> payments = [];

  String cardType = 'Visa';
  bool isLoading = true;
  bool isSaving = false;
  bool showAddForm = false;

  @override
  void initState() {
    super.initState();
    loadPayments();
  }

  @override
  void dispose() {
    cardholderController.dispose();
    cardNumberController.dispose();
    expiryController.dispose();
    super.dispose();
  }

  // format 1234567890123456 -> 1234 5678 9012 3456
  String formatCardNumber(String n) {
    return n
        .replaceAllMapped(RegExp(r'.{1,4}'), (m) => '${m.group(0)} ')
        .trim();
  }

  Future<void> loadPayments() async {
    try {
      final result = await widget.paymentService.getPayments();

      if (!mounted) return;

      setState(() {
        payments = result;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() => isLoading = false);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load payment methods: $e')),
      );
    }
  }

  Future<void> addPayment() async {
    final name = cardholderController.text.trim();
    final cardNumber = cardNumberController.text.replaceAll(' ', '');
    final expiry = expiryController.text.trim();

    if (name.isEmpty || cardNumber.isEmpty || expiry.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please complete all payment details.'),
        ),
      );
      return;
    }

    if (!RegExp(r'^[0-9]{16}$').hasMatch(cardNumber) ||
        !RegExp(r'^(0[1-9]|1[0-2])/[0-9]{2}$').hasMatch(expiry)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Enter a valid 16-digit card number and expiry date.'),
        ),
      );
      return;
    }

    setState(() => isSaving = true);

    try {
      await widget.paymentService.addPayment(
        cardholderName: name,
        cardNumber: cardNumber,
        cardType: cardType,
        expiryDate: expiry,
      );

      if (!mounted) return;

      cardholderController.clear();
      cardNumberController.clear();
      expiryController.clear();

      setState(() {
        isSaving = false;
        showAddForm = false;
      });

      await loadPayments();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Payment method added successfully.'),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      setState(() => isSaving = false);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add payment method: $e')),
      );
    }
  }

  Future<void> deletePayment(int id) async {
    try {
      await widget.paymentService.deletePayment(id);
      await loadPayments();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Payment method deleted.')),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete payment method: $e')),
      );
    }
  }

  Future<void> setDefaultPayment(int id) async {
    try {
      await widget.paymentService.setDefaultPayment(id);
      await loadPayments();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Default card updated.')),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update default card: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black87;
    final subTextColor = isDark ? Colors.white60 : Colors.black54;
    final fieldColor = isDark ? Colors.grey.shade900 : Colors.grey.shade100;

    return Dialog(
      backgroundColor: isDark ? Colors.grey.shade50 : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Payment Methods',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context, false),
                    icon: Icon(Icons.close, color: textColor),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              Text(
                'Manage your saved payment methods.',
                style: TextStyle(color: subTextColor),
              ),

              const SizedBox(height: 20),

              if (isLoading)
                const Center(child: CircularProgressIndicator())
              else if (payments.isEmpty)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 24),
                    child: Column(
                      children: [
                        Icon(
                          Icons.credit_card,
                          size: 42,
                          color: subTextColor,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'No payment methods yet.',
                          style: TextStyle(color: subTextColor),
                        ),
                      ],
                    ),
                  ),
                )
              else
                ...payments.map((payment) {
                  final isDefault = payment['is_default'] == true;

                  // kartu baru tampil nomor penuh, kartu lama tetap 4 digit terakhir
                  final cardText = '${payment['card_type']} •••• ${payment['card_last4']}';
                  // final cardText = payment['card_number'] != null
                  //     ? '${payment['card_type']}  ${formatCardNumber(payment['card_number'].toString())}'
                  //     : '${payment['card_type']} •••• ${payment['card_last4']}';

                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: fieldColor,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isDefault
                            ? Colors.black54
                            : Colors.transparent,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.credit_card,
                          size: 30,
                          color: textColor,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                cardText,
                                style: TextStyle(
                                  color: textColor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                payment['cardholder_name'],
                                style: TextStyle(
                                  color: subTextColor,
                                  fontSize: 12,
                                ),
                              ),
                              if (isDefault)
                                const Text(
                                  'Default Card',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                            ],
                          ),
                        ),
                        PopupMenuButton<String>(
                          onSelected: (value) {
                            final id = payment['id'] as int;

                            if (value == 'default') {
                              setDefaultPayment(id);
                            } else if (value == 'delete') {
                              deletePayment(id);
                            }
                          },
                          itemBuilder: (context) => [
                            if (!isDefault)
                              const PopupMenuItem(
                                value: 'default',
                                child: Text('Set as Default'),
                              ),
                            const PopupMenuItem(
                              value: 'delete',
                              child: Text('Delete'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                }),

              const SizedBox(height: 12),

              if (showAddForm) ...[
                Divider(color: subTextColor),
                const SizedBox(height: 12),

                Text(
                  'Add New Card',
                  style: TextStyle(
                    color: textColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 14),

                TextField(
                  controller: cardholderController,
                  decoration: InputDecoration(
                    labelText: 'Cardholder Name',
                    filled: true,
                    fillColor: fieldColor,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                TextField(
                  controller: cardNumberController,
                  keyboardType: TextInputType.number,
                  maxLength: 16,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: InputDecoration(
                    labelText: 'Card Number',
                    hintText: '1234567890123456',
                    counterText: '',
                    filled: true,
                    fillColor: fieldColor,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                DropdownButtonFormField<String>(
                  value: cardType,
                  decoration: InputDecoration(
                    labelText: 'Card Type',
                    filled: true,
                    fillColor: fieldColor,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  items: ['Visa', 'Mastercard']
                      .map(
                        (type) => DropdownMenuItem(
                      value: type,
                      child: Text(type),
                    ),
                  )
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() => cardType = value);
                    }
                  },
                ),

                const SizedBox(height: 12),

                TextField(
                  controller: expiryController,
                  keyboardType: TextInputType.datetime,
                  maxLength: 5,
                  decoration: InputDecoration(
                    labelText: 'Expiry Date (MM/YY)',
                    counterText: '',
                    hintText: 'MM/YY',
                    filled: true,
                    fillColor: fieldColor,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: isSaving ? null : addPayment,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: isSaving
                        ? const SizedBox(
                      height: 18,
                      width: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                        : const Text('Save Card'),
                  ),
                ),
              ] else
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      setState(() => showAddForm = true);
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('Add New Card'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: textColor,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}