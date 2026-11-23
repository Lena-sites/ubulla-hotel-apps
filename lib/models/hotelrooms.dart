class HotelRooms {
  final int id;
  final int hotelId;
  final String roomType;
  final int capacity;
  final int totalRooms;
  final int pricePerNight;
  final String currency;

  HotelRooms({
    required this.id,
    required this.hotelId,
    required this.roomType,
    required this.capacity,
    required this.totalRooms,
    required this.pricePerNight,
    required this.currency,
  });

  factory HotelRooms.fromJson(Map<String, dynamic> json) {
    final rawPrices = json['hotel_prices'];

    final price = rawPrices is List
        ? (rawPrices.isNotEmpty ? rawPrices.first : null)
        : rawPrices is Map
        ? rawPrices
        : null;

    return HotelRooms(
      id: (json['id'] as num).toInt(),
      hotelId: (json['hotel_id'] as num).toInt(),
      roomType: json['room_type'] ?? '',
      capacity: (json['capacity'] as num?)?.toInt() ?? 0,
      totalRooms: (json['total_rooms'] as num?)?.toInt() ?? 0,
      pricePerNight:
      (price?['price_per_night'] as num?)?.toInt() ?? 0,
      currency: price?['currency'] ?? 'IDR',
    );
  }
}
