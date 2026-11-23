class Transaction {
  final int hotelId;
  final String hotelName;
  final int guest;
  final int room;
  final DateTime checkIn;
  final DateTime checkOut;
  final int totalPrice;
  final String paymentMethod;

  Transaction({
    required this.hotelId,
    required this.hotelName,
    required this.guest,
    required this.room,
    required this.checkIn,
    required this.checkOut,
    required this.totalPrice,
    required this.paymentMethod,
  });

  Map<String, dynamic> toJson(String userId) { //toJson itu mengubah data menjadi format yang bisa dikirim ke Supabase
    return {
      'user_id': userId,
      'hotel_id': hotelId,
      'hotel_name': hotelName,
      'guest': guest,
      'room': room,
      'check_in': checkIn.toIso8601String().split('T')[0],
      'check_out': checkOut.toIso8601String().split('T')[0],
      'total_price': totalPrice,
      'payment_method': paymentMethod,

      'status': 'success',
      'booking_status': 'ongoing',
    };
  }
}
