import 'package:flutter/material.dart';
import 'package:hotelapps/services/reservation_service.dart';

class ReservationReportsPage extends StatefulWidget {
  const ReservationReportsPage({super.key});

  @override
  State<ReservationReportsPage> createState() =>
      _ReservationReportsPageState();
}

class _ReservationReportsPageState extends State<ReservationReportsPage> {
  final reservationService = ReservationService();

  late Future<List<Map<String, dynamic>>> reservationsFuture;

  @override
  void initState() {
    super.initState();
    reservationsFuture = reservationService.getPartnerReservations();
  }

  @override
  Widget build(BuildContext context) {
    const green = Color(0xFF10B981);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text('Reservation Reports'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: FutureBuilder(
        future: reservationsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final reservations = snapshot.data ?? [];

          if (reservations.isEmpty) {
            return const Center(child: Text('No reservations yet.'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: reservations.length,
            itemBuilder: (context, index) {
              final item = reservations[index];
              final customer = item['customer'];
              final roomInfo = item['room_info'];

              return Card(
                color: Colors.white,
                margin: const EdgeInsets.only(bottom: 12),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item['hotel_name'] ?? 'Hotel',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Divider(),

                      Text('Customer: ${customer?['name'] ?? '-'}'),
                      Text('Email: ${customer?['email'] ?? '-'}'),
                      Text('Room: ${roomInfo?['room_type'] ?? '-'}'),
                      Text('Check-in: ${item['check_in'] ?? '-'}'),
                      Text('Check-out: ${item['check_out'] ?? '-'}'),
                      Text('Guests: ${item['guest'] ?? 0}'),
                      Text('Rooms: ${item['room'] ?? 0}'),

                      const Divider(),

                      Text(
                        'Total Price: Rp ${item['total_price'] ?? 0}',
                        style: const TextStyle(
                          color: green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),

                      Text('Payment Status: ${item['status'] ?? '-'}'),
                      Text('Booking Status: ${item['booking_status'] ?? '-'}'),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
