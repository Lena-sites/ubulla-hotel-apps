import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class BecomePartnerPage extends StatefulWidget {
  const BecomePartnerPage({super.key});

  @override
  State<BecomePartnerPage> createState() => _BecomePartnerPageState();
}

class _BecomePartnerPageState extends State<BecomePartnerPage> {
  final _formKey = GlobalKey<FormState>();
  final supabase = Supabase.instance.client;
  bool _isSubmitting = false;

  final TextEditingController _hotelNameController =
  TextEditingController();
  final TextEditingController _hotelAddressController =
  TextEditingController();
  final TextEditingController _descriptionController =
  TextEditingController();

  final List<Map<String, TextEditingController>> _roomControllers = [];

  void _addRoom() {
    setState(() {
      _roomControllers.add({
        'type': TextEditingController(),
        'total': TextEditingController(text: '5'),
        'price': TextEditingController(),
      });
    });
  }

  void _removeRoom(int index) {
    setState(() {
      for (final controller in _roomControllers[index].values) {
        controller.dispose();
      }

      _roomControllers.removeAt(index);
    });
  }

  Future<void> _submitApplication() async {
    if (!_formKey.currentState!.validate()) return;

    if (_roomControllers.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please add at least one room type'),
        ),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      final userId = supabase.auth.currentUser!.id;

      final rooms = _roomControllers.map((room) {
        return {
          'room_type': room['type']!.text.trim(),
          'total_rooms': int.parse(room['total']!.text),
          'price_per_night': double.parse(room['price']!.text),
          'currency': 'IDR',
        };
      }).toList();

      await supabase.from('partner_applications').insert({
        'user_id': userId,
        'hotel_name': _hotelNameController.text.trim(),
        'hotel_address': _hotelAddressController.text.trim(),
        'description': _descriptionController.text.trim(),
        'rooms': rooms,
      });

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Partner application submitted successfully!'),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to submit application: $e'),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Become a Partner'),
        backgroundColor: const Color(0xFF10A05A),
        foregroundColor: Colors.white,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Register Your Hotel',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              const Text(
                'Fill in your hotel information to become one of our partners.',
                style: TextStyle(color: Colors.grey),
              ),

              const SizedBox(height: 24),

              // HOTEL INFORMATION

              const Text(
                'Hotel Name',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),

              const SizedBox(height: 8),

              TextFormField(
                controller: _hotelNameController,
                validator: (value) =>
                value == null || value.trim().isEmpty
                    ? 'Hotel name is required'
                    : null,
                decoration: const InputDecoration(
                  hintText: 'Enter hotel name',
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 16),

              const Text(
                'Hotel Address',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),

              const SizedBox(height: 8),

              TextFormField(
                controller: _hotelAddressController,
                maxLines: 2,
                validator: (value) =>
                value == null || value.trim().isEmpty
                    ? 'Hotel address is required'
                    : null,
                decoration: const InputDecoration(
                  hintText: 'Enter hotel address',
                  border: OutlineInputBorder(),
                ),
              ),


              const SizedBox(height: 16),

              const Text(
                'Hotel Description',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),

              const SizedBox(height: 8),

              TextFormField(
                controller: _descriptionController,
                maxLines: 4,
                decoration: const InputDecoration(
                  hintText: 'Describe your hotel',
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 28),

              // ROOM DETAILS

              const Text(
                'Room Details',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              const Text(
                'Add the room types available at your hotel.',
                style: TextStyle(color: Colors.grey),
              ),

              const SizedBox(height: 16),

              ...List.generate(_roomControllers.length, (index) {
                final room = _roomControllers[index];

                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                'Room ${index + 1}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),

                            IconButton(
                              onPressed: () => _removeRoom(index),
                              icon: const Icon(
                                Icons.delete_outline,
                                color: Colors.red,
                              ),
                            ),
                          ],
                        ),

                        DropdownButtonFormField<String>(
                          value: room['type']!.text.isEmpty
                              ? null
                              : room['type']!.text,
                          decoration: const InputDecoration(
                            labelText: 'Room Type',
                            border: OutlineInputBorder(),
                          ),
                          items: const [
                            DropdownMenuItem(
                              value: 'Standard',
                              child: Text('Standard'),
                            ),
                            DropdownMenuItem(
                              value: 'Deluxe',
                              child: Text('Deluxe'),
                            ),
                            DropdownMenuItem(
                              value: 'Suite',
                              child: Text('Suite'),
                            ),
                          ],
                          onChanged: (value) {
                            room['type']!.text = value ?? '';
                          },
                          validator: (value) =>
                          value == null ? 'Please select a room type' : null,
                        ),

                        const SizedBox(height: 12),

                        TextFormField(
                          controller: room['total'],
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          validator: (value) =>
                          (int.tryParse(value ?? '') ?? 0) <= 0
                              ? 'Enter a valid quantity'
                              : null,
                          decoration: const InputDecoration(
                            labelText: 'Total Rooms',
                          ),
                        ),

                        const SizedBox(height: 12),

                        TextFormField(
                          controller: room['price'],
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          validator: (value) =>
                          (int.tryParse(value ?? '') ?? 0) <= 0
                              ? 'Enter a valid price'
                              : null,
                          decoration: const InputDecoration(
                            labelText: 'Price per Night (IDR)',
                            hintText: 'Example: 750000',
                          ),
                        ),

                        const SizedBox(height: 12),


                      ],
                    ),
                  ),
                );
              }),

              OutlinedButton.icon(
                onPressed: _addRoom,
                icon: const Icon(Icons.add),
                label: const Text('Add Room Type'),
              ),

              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isSubmitting ? null : _submitApplication,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF10A05A),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: _isSubmitting
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('Submit Application'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}