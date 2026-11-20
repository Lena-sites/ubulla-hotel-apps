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
  final int pricePerNight;
  final String currency;
  final String category;

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
      required this.category
  });

  //mengubah menjadi objek hotel supaya bisa di pake ama flutter (ini dia ngambil datanya uda dari tabel supabase)
  factory Hotels.fromJson(Map<String, dynamic> json){
    // final properties = json['properties'] ?? {};
    // final accommodation = properties['accommodation'] ?? {};

    final rawPrices = json['hotel_prices'];
    // Mengubah data harga menjadi Map agar mudah dibaca
    final Map<String, dynamic>? price =
    rawPrices is List
        ? (rawPrices.isNotEmpty
        ? Map<String, dynamic>.from(rawPrices[0])
        : null)
        : rawPrices is Map
        ? Map<String, dynamic>.from(rawPrices)
        : null;

    return Hotels(
      id: json['geoapify_place_id'] ?? '',
      name: json['name'] ?? 'Unnamed Hotel',
      address: json['address'] ?? '',
      city: json['city'] ?? '',
      country: json['country'] ?? '',
      latitude: (json['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (json['longitude'] as num?)?.toDouble() ?? 0.0,
      hotelStars: json['hotel_stars'] as int?,

      pricePerNight: (price?['price_per_night'] as num?)?.toInt() ?? 0,
      currency: price?['currency'] ?? 'IDR',
      category: json['hotel_categories']?['category_name'] ?? '',

      // pricePerNight: (json['hotel_price'][0]['price_per_night'] as num).toDouble(),
      // currency: json['hotel_prices'][0]['currency']
    );
  }
}

