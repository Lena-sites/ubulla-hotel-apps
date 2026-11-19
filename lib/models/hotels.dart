//ini atribut data hotels
class Hotels {
  final String id;
  final String name;
  final String address;
  final String city;
  final String country;
  final double latitude;
  final double longitude;
  final int? hotelStars;

  Hotels({
      required this.id,
      required this.name,
      required this.address,
      required this.city,
      required this.country,
      required this.latitude,
      required this.longitude,
      required this.hotelStars,
  });

  //mengubah menjadi objek hotel supaya bisa di pake ama flutter (ini dia ngambil datanya uda dari tabel supabase)
  factory Hotels.fromJson(Map<String, dynamic> json){
    // final properties = json['properties'] ?? {};
    // final accommodation = properties['accommodation'] ?? {};

    return Hotels(
      id: json['geoapify_place_id'] ?? '',
      name: json['name'] ?? 'Unnamed Hotel',
      address: json['address'] ?? '',
      city: json['city'] ?? '',
      country: json['country'] ?? '',
      latitude: (json['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (json['longitude'] as num?)?.toDouble() ?? 0.0,
      hotelStars: json['hotel_stars'] as int?,
    );
  }
}

