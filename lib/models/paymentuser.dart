class PaymentUser {
  final int id;
  final String userId;
  final String cardholderName;
  final String cardLast4;
  final String cardType;
  final String expiryDate;
  final bool isDefault;
  final DateTime createdAt;

  PaymentUser({
    required this.id,
    required this.userId,
    required this.cardholderName,
    required this.cardLast4,
    required this.cardType,
    required this.expiryDate,
    required this.isDefault,
    required this.createdAt,
  });

  factory PaymentUser.fromJson(Map<String, dynamic> json) {
    return PaymentUser(
      id: json['id'],
      userId: json['user_id'],
      cardholderName: json['cardholder_name'] ?? '',
      cardLast4: json['card_last4'] ?? '',
      cardType: json['card_type'] ?? '',
      expiryDate: json['expiry_date'] ?? '',
      isDefault: json['is_default'] ?? false,
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}