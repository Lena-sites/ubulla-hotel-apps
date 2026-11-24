class PaymentMethods {
  final int id;
  final String methodName;
  final String? imageUrl;
  final bool isActive;

  PaymentMethods({
    required this.id,
    required this.methodName,
    this.imageUrl,
    required this.isActive,
  });

  factory PaymentMethods.fromJson(Map<String, dynamic> json) {
    return PaymentMethods(
      id: (json['id'] as num).toInt(),
      methodName: json['method_name'] ?? '',
      imageUrl: json['image_url'],
      isActive: json['is_active'] ?? true,
    );
  }
}