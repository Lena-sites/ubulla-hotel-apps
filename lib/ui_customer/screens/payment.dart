import 'package:flutter/material.dart';
import 'package:hotelapps/ui_customer/screens/confirmpayment.dart';
import 'package:hotelapps/models/hotels.dart';
import 'package:hotelapps/models/paymentuser.dart';
import 'package:hotelapps/services/paymentuser_service.dart';
import 'package:hotelapps/models/paymentmethods.dart';
import 'package:hotelapps/services/paymentmethod_service.dart';

class PaymentPage extends StatefulWidget {
  // Pengambilan variabel dari CustomPage
  final Hotels hotel;
  final int guest;
  final int room;
  final int roomId;
  final int totalPrice;
  final DateTime checkInDate;
  final DateTime checkOutDate;

  const PaymentPage({
    super.key,
    required this.hotel,
    required this.guest,
    required this.room,
    required this.roomId,
    required this.totalPrice,
    required this.checkInDate,
    required this.checkOutDate,
  });

  @override
  State<PaymentPage> createState() => _PaymentPage();
}

class _PaymentPage extends State<PaymentPage> {
  // Service metode pembayaran
  final PaymentMethodService methodService = PaymentMethodService();

  // Service kartu pengguna
  final PaymentUserService paymentService = PaymentUserService();

  List<PaymentMethods> paymentMethods = [];
  PaymentUser? defaultPayment;

  int? selected;

  bool isLoadingMethods = true;
  bool isLoadingPayment = true;

  @override
  void initState() {
    super.initState();
    loadDefaultPayment();
    loadPaymentMethods();
  }

  // Mengambil kartu default pengguna
  Future<void> loadDefaultPayment() async {
    try {
      final payments = await paymentService.getPayments();

      if (!mounted) return;

      setState(() {
        final defaultCards = payments
            .where((payment) => payment.isDefault)
            .toList();

        defaultPayment = defaultCards.isNotEmpty
            ? defaultCards.first
            : null;

        isLoadingPayment = false;
      });
    } catch (e) {
      debugPrint('Gagal mengambil kartu default: $e');

      if (!mounted) return;

      setState(() {
        isLoadingPayment = false;
      });
    }
  }

  // Mengambil metode pembayaran aktif dari Supabase
  Future<void> loadPaymentMethods() async {
    try {
      final methods = await methodService.getPaymentMethods();

      if (!mounted) return;

      setState(() {
        paymentMethods = methods;
        selected = methods.isNotEmpty ? methods.first.id : null;
        isLoadingMethods = false;
      });
    } catch (e) {
      debugPrint('Gagal mengambil metode pembayaran: $e');

      if (!mounted) return;

      setState(() {
        isLoadingMethods = false;
      });
    }
  }

  // Memeriksa apakah metode yang dipilih adalah kartu kredit/debit
  bool get isCreditCard {
    final method = paymentMethods.where(
          (item) => item.id == selected,
    );

    return method.isNotEmpty &&
        method.first.methodName == 'Credit/Debit Card';
  }

  // Melanjutkan ke halaman konfirmasi
  void continuePayment() {
    if (selected == null) return;

    final selectedMethod = paymentMethods.firstWhere(
          (method) => method.id == selected,
    );

    if (selectedMethod.methodName == 'Credit/Debit Card' &&
        defaultPayment == null) {
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ConfirmPage(
          hotel: widget.hotel,
          guest: widget.guest,
          room: widget.room,
          roomId: widget.roomId,
          totalPrice: widget.totalPrice,

          payMet: selectedMethod.methodName == 'Credit/Debit Card'
              ? '${selectedMethod.methodName} - ${defaultPayment!.cardType} •••• ${defaultPayment!.cardLast4}'
              : selectedMethod.methodName,

          checkInDate: widget.checkInDate,
          checkOutDate: widget.checkOutDate,

          cardholderName: selectedMethod.methodName == 'Credit/Debit Card'
              ? defaultPayment!.cardholderName
              : null,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],

      appBar: AppBar(
        backgroundColor: Colors.grey,
        title: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'UBULLA',
                    style: TextStyle(
                      fontFamily: 'Cormorant_Garamond',
                      fontSize: 18,
                    ),
                  ),
                  Text(
                    'Hotel and Resort',
                    style: TextStyle(
                      fontFamily: 'Cormorant_Garamond',
                      fontSize: 9,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 5),
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                'assets/images/logo.png',
                width: 40,
                height: 40,
              ),
            ),
          ],
        ),
      ),

      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Judul Payment Methods
              Text(
                'Payment Methods',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),

              SizedBox(height: 20),

              // Daftar metode pembayaran dari Supabase
              Expanded(
                child: isLoadingMethods
                    ? Center(
                  child: CircularProgressIndicator(),
                )
                    : paymentMethods.isEmpty
                    ? Center(
                  child: Text('No payment methods available'),
                )
                    : ListView.builder(
                  itemCount: paymentMethods.length,
                  itemBuilder: (context, index) {
                    final method = paymentMethods[index];

                    final isCardMethod =
                        method.methodName == 'Credit/Debit Card';

                    final isCardUnavailable =
                        isCardMethod &&
                            (isLoadingPayment || defaultPayment == null);

                    final isSelected = selected == method.id;

                    return Padding(
                      padding: EdgeInsets.only(bottom: 15),
                      child: GestureDetector(
                        onTap: isCardUnavailable
                            ? null
                            : () {
                          setState(() {
                            selected = method.id;
                          });
                        },

                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 22,
                          ),
                          decoration: BoxDecoration(
                            color: isCardUnavailable
                                ? Colors.grey.shade200
                                : Colors.white,
                            borderRadius: BorderRadius.circular(15),
                          ),

                          child: Row(
                            children: [
                              Icon(
                                isCardMethod
                                    ? Icons.credit_card
                                    : Icons.account_balance_wallet,
                                color: Colors.blueGrey,
                                size: 28,
                              ),

                              SizedBox(width: 16),

                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      method.methodName,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),

                                    // Detail kartu default
                                    if (isCardMethod) ...[
                                      if (isLoadingPayment)
                                        Padding(
                                          padding:
                                          EdgeInsets.only(top: 5),
                                          child: Text(
                                            'Loading saved card...',
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey,
                                            ),
                                          ),
                                        )
                                      else if (defaultPayment != null) ...[
                                        SizedBox(height: 5),

                                        Text(
                                          '${defaultPayment!.cardType} •••• ${defaultPayment!.cardLast4}',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey,
                                          ),
                                        ),

                                        Text(
                                          defaultPayment!
                                              .cardholderName,
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ] else
                                        Padding(
                                          padding:
                                          EdgeInsets.only(top: 5),
                                          child: Text(
                                            'No saved card available',
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ),
                                    ],
                                  ],
                                ),
                              ),

                              Icon(
                                isSelected
                                    ? Icons.radio_button_checked
                                    : Icons.radio_button_unchecked,
                                color: Color(0xFF10B981),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              SizedBox(height: 15),

              // Tombol Continue
              ElevatedButton(
                onPressed: isLoadingMethods ||
                    isLoadingPayment ||
                    selected == null ||
                    paymentMethods.isEmpty ||
                    (isCreditCard && defaultPayment == null)
                    ? null
                    : continuePayment,

                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF10B981),
                  disabledBackgroundColor: Colors.grey,
                  minimumSize: Size(double.infinity, 55),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),

                child: Text(
                  'Continue',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
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