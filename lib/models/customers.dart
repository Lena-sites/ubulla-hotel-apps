class Customers {
  final String id;
  final String name;
  final String email;
  final String? avatarUrl;
  final DateTime? createdAt;

  Customers({
    required this.id,
    required this.name,
    required this.email,
    this.avatarUrl,
    this.createdAt,
  });

  factory Customers.fromJson(Map<String, dynamic> json) {
    return Customers(
      id: json['id'],
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      avatarUrl: json['avatar_url'],
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
    );
  }
}