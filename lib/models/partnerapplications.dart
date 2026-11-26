class PartnerApplications {
  final String id;
  final String userId;
  final String hotelName;
  final String hotelAddress;
  final String? description;
  final String status;
  final String? adminNote;
  final DateTime? createdAt;
  final DateTime? reviewedAt;
  final List<Map<String, dynamic>> rooms;

  PartnerApplications({
    required this.id,
    required this.userId,
    required this.hotelName,
    required this.hotelAddress,
    this.description,
    required this.status,
    this.adminNote,
    this.createdAt,
    this.reviewedAt,
    this.rooms = const [],
  });

  factory PartnerApplications.fromJson(Map<String, dynamic> json) {
    return PartnerApplications(
      id: json['id'],
      userId: json['user_id'],
      hotelName: json['hotel_name'] ?? '',
      hotelAddress: json['hotel_address'] ?? '',
      description: json['description'],
      status: json['status'] ?? 'pending',
      adminNote: json['admin_note'],
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      reviewedAt: json['reviewed_at'] != null
          ? DateTime.parse(json['reviewed_at'])
          : null,
      rooms: List<Map<String, dynamic>>.from(
        json['rooms'] ?? [],
      ),
    );
  }
}