//ini atribut data hotels
import 'package:hotelapps/models/hotelrooms.dart';

class Hotels {
  // final String id;
  final int id;
  final String name;
  final String address;
  final String city;
  final String country;
  final double latitude;
  final double longitude;
  final int? hotelStars;
  final int pricePerNight;
  final String currency;
  final String category;
  final String imageUrl;
  final String details;
  final List<String> facilities;

  Hotels({
      required this.id,
      required this.name,
      required this.address,
      required this.city,
      required this.country,
      required this.latitude,
      required this.longitude,
      required this.hotelStars,
      required this.pricePerNight,
      required this.currency,
      required this.category,
      required this.imageUrl,
      required this.details,
      required this.facilities,
  });

  //mengubah menjadi objek hotel supaya bisa di pake ama flutter (ini dia ngambil datanya uda dari tabel supabase)

  factory Hotels.fromJson(Map<String, dynamic> json) {
    final rawRooms = json['hotel_rooms'];

    final rooms = rawRooms is List
        ? rawRooms
        : rawRooms is Map
        ? [rawRooms]
        : [];

    final hotelRooms = rooms.map((room) {
      return HotelRooms.fromJson(
        Map<String, dynamic>.from(room),
      );
    }).toList();

    final standardRoom = hotelRooms.where(
          (room) => room.roomType == 'Standard',
    ).toList();

    final standardPrice = standardRoom.isNotEmpty
        ? standardRoom.first
        : null;

    return Hotels(
      // id: json['id'].toString(),
      id: (json['id'] as num).toInt(),
      name: json['name'] ?? 'Unnamed Hotel',
      address: json['address'] ?? '',
      city: json['city'] ?? '',
      country: json['country'] ?? '',
      latitude: (json['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (json['longitude'] as num?)?.toDouble() ?? 0.0,
      hotelStars: json['hotel_stars'] as int?,

      pricePerNight: standardPrice?.pricePerNight ?? 0,
      currency: standardPrice?.currency ?? 'IDR',
      category: json['hotel_categories']?['category_name'] ?? '',
      // imageUrl: (json['image_url'] ?? '').toString(),
      imageUrl: json['image_url'] ?? '',
      details: json['details'] ?? '',
      facilities: List<String>.from(json['facilities'] ?? []),
    );
  }
}

