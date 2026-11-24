class HotelGallery {
  final int id;
  final int hotelId;
  final String imageUrl;

  HotelGallery({
    required this.id,
    required this.hotelId,
    required this.imageUrl,
  });

  factory HotelGallery.fromJson(Map<String, dynamic> json) {
    return HotelGallery(
      id: (json['id'] as num).toInt(),
      hotelId: (json['hotel_id'] as num).toInt(),
      imageUrl: json['image_url'],
    );
  }
}
