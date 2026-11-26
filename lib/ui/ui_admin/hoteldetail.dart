import 'package:flutter/material.dart';
import 'package:hotelapps/models/hotels.dart';
import 'package:hotelapps/services/hotelmanagement_service.dart';
import 'package:hotelapps/models/hotelrooms.dart';

class HotelDetailPage extends StatefulWidget {
  final Hotels hotel;

  const HotelDetailPage({
    super.key,
    required this.hotel,
  });

  @override
  State<HotelDetailPage> createState() => _HotelDetailPageState();
}

class _HotelDetailPageState extends State<HotelDetailPage> {

  final HotelManagementService _service = HotelManagementService();
  late String hotelName;
  late String hotelAddress;
  late String hotelCity;
  late String hotelCountry;
  late double hotelLatitude;
  late double hotelLongitude;
  late String hotelStatus;
  late int hotelStars;
  late String hotelDescription;
  late List<String> hotelFacilities;
  final List<String> availableFacilities = [
    'Swimming Pool',
    'WiFi',
    'Restaurant',
    'Parking',
    'Meeting Room',
    'Fitness Center',
  ];
  late List<HotelRooms> hotelRooms;
  final List<String> availableRoomTypes = [
    'Standard',
    'Deluxe',
    'Suite',
  ];

  //supaya nama hotel yang tampil bisa diperbarui menggunakan setState() setelah berhasil disimpan ke Supabase
  @override
  void initState() {
    super.initState();
    hotelName = widget.hotel.name;
    hotelAddress = widget.hotel.address;
    hotelCity = widget.hotel.city;
    hotelCountry = widget.hotel.country;
    hotelLatitude = widget.hotel.latitude;
    hotelLongitude = widget.hotel.longitude;
    hotelStatus = widget.hotel.status;
    hotelStars = widget.hotel.hotelStars ?? 0;
    hotelDescription = widget.hotel.details ?? '';
    hotelFacilities = List<String>.from(widget.hotel.facilities ?? []);
    hotelRooms = List<HotelRooms>.from(widget.hotel.rooms);
  }

  Future<void> editHotelName() async {
    final controller = TextEditingController(text: hotelName);

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Hotel Name'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(
              labelText: 'Hotel Name',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                final newName = controller.text.trim();

                if (newName.isEmpty) return;

                try {
                  await _service.updateHotelName(
                    widget.hotel.id,
                    newName,
                  );

                  if (!mounted) return;

                  setState(() {
                    hotelName = newName;
                  });

                  Navigator.pop(context);
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to update hotel name: $e')),
                  );
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );

    controller.dispose();
  }

  //fungsi edit Address
  Future<void> editHotelAddress() async {
    final controller = TextEditingController(text: hotelAddress);

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Hotel Address'),
          content: TextField(
            controller: controller,
            maxLines: 2,
            decoration: const InputDecoration(
              labelText: 'Hotel Address',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                final newAddress = controller.text.trim();

                if (newAddress.isEmpty) return;

                try {
                  await _service.updateHotelAddress(
                    widget.hotel.id,
                    newAddress,
                  );

                  if (!mounted) return;

                  setState(() {
                    hotelAddress = newAddress;
                  });

                  Navigator.pop(context);
                } catch (e) {
                  if (!mounted) return;

                  ScaffoldMessenger.of(this.context).showSnackBar(
                    SnackBar(content: Text('Failed to update address: $e')),
                  );
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );

    controller.dispose();
  }

  Future<void> editHotelCity() async {
    final controller = TextEditingController(text: hotelCity);

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Hotel City'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(
              labelText: 'City',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                final newCity = controller.text.trim();

                if (newCity.isEmpty) return;

                try {
                  await _service.updateHotelCity(
                    widget.hotel.id,
                    newCity,
                  );

                  if (!mounted) return;

                  setState(() {
                    hotelCity = newCity;
                  });

                  Navigator.pop(context);
                } catch (e) {
                  if (!mounted) return;

                  ScaffoldMessenger.of(this.context).showSnackBar(
                    SnackBar(content: Text('Failed to update city: $e')),
                  );
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );

    controller.dispose();
  }

  Future<void> editHotelCountry() async {
    final controller = TextEditingController(text: hotelCountry);

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Hotel Country'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(
              labelText: 'Country',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                final newCountry = controller.text.trim();

                if (newCountry.isEmpty) return;

                try {
                  await _service.updateHotelCountry(
                    widget.hotel.id,
                    newCountry,
                  );

                  if (!mounted) return;

                  setState(() {
                    hotelCountry = newCountry;
                  });

                  Navigator.pop(context);
                } catch (e) {
                  if (!mounted) return;

                  ScaffoldMessenger.of(this.context).showSnackBar(
                    SnackBar(content: Text('Failed to update country: $e')),
                  );
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );

    controller.dispose();
  }

  Future<void> editHotelCoordinates() async {
    final latitudeController = TextEditingController(
      text: hotelLatitude.toString(),
    );
    final longitudeController = TextEditingController(
      text: hotelLongitude.toString(),
    );

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Hotel Coordinates'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: latitudeController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                  signed: true,
                ),
                decoration: const InputDecoration(
                  labelText: 'Latitude',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: longitudeController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                  signed: true,
                ),
                decoration: const InputDecoration(
                  labelText: 'Longitude',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                final latitude = double.tryParse(
                  latitudeController.text.trim(),
                );
                final longitude = double.tryParse(
                  longitudeController.text.trim(),
                );

                if (latitude == null ||
                    longitude == null ||
                    latitude < -90 ||
                    latitude > 90 ||
                    longitude < -180 ||
                    longitude > 180) {
                  ScaffoldMessenger.of(this.context).showSnackBar(
                    const SnackBar(
                      content: Text('Please enter valid coordinates'),
                    ),
                  );
                  return;
                }

                try {
                  await _service.updateHotelCoordinates(
                    widget.hotel.id,
                    latitude,
                    longitude,
                  );

                  if (!mounted) return;

                  setState(() {
                    hotelLatitude = latitude;
                    hotelLongitude = longitude;
                  });

                  Navigator.pop(context);
                } catch (e) {
                  if (!mounted) return;

                  ScaffoldMessenger.of(this.context).showSnackBar(
                    SnackBar(
                      content: Text('Failed to update coordinates: $e'),
                    ),
                  );
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );

    latitudeController.dispose();
    longitudeController.dispose();
  }

  Future<void> editHotelStatus() async {
    String selectedStatus = hotelStatus;

    await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Edit Hotel Status'),
              content: DropdownButtonFormField<String>(
                value: selectedStatus,
                decoration: const InputDecoration(
                  labelText: 'Hotel Status',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(
                    value: 'Active',
                    child: Text('Active'),
                  ),
                  DropdownMenuItem(
                    value: 'Non-active',
                    child: Text('Non-active'),
                  ),
                  DropdownMenuItem(
                    value: 'Suspend',
                    child: Text('Suspend'),
                  ),
                ],
                onChanged: (value) {
                  if (value != null) {
                    setDialogState(() {
                      selectedStatus = value;
                    });
                  }
                },
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    try {
                      await _service.changeHotelStatus(
                        widget.hotel.id,
                        selectedStatus,
                      );

                      if (!mounted) return;

                      setState(() {
                        hotelStatus = selectedStatus;
                      });

                      Navigator.pop(context);
                    } catch (e) {
                      if (!mounted) return;

                      ScaffoldMessenger.of(this.context).showSnackBar(
                        SnackBar(
                          content: Text('Failed to update hotel status: $e'),
                        ),
                      );
                    }
                  },
                  child: const Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> editHotelStars() async {
    int selectedStars = hotelStars;

    await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Edit Hotel Stars'),
              content: DropdownButtonFormField<int>(
                value: selectedStars == 0 ? null : selectedStars,
                decoration: const InputDecoration(
                  labelText: 'Hotel Stars',
                  border: OutlineInputBorder(),
                ),
                items: List.generate(5, (index) {
                  final stars = index + 1;

                  return DropdownMenuItem(
                    value: stars,
                    child: Text('$stars Stars'),
                  );
                }),
                onChanged: (value) {
                  if (value != null) {
                    setDialogState(() {
                      selectedStars = value;
                    });
                  }
                },
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (selectedStars == 0) return;

                    try {
                      await _service.updateHotelStars(
                        widget.hotel.id,
                        selectedStars,
                      );

                      if (!mounted) return;

                      setState(() {
                        hotelStars = selectedStars;
                      });

                      Navigator.pop(context);
                    } catch (e) {
                      if (!mounted) return;

                      ScaffoldMessenger.of(this.context).showSnackBar(
                        SnackBar(
                          content: Text('Failed to update hotel stars: $e'),
                        ),
                      );
                    }
                  },
                  child: const Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> editHotelDescription() async {
    final controller = TextEditingController(text: hotelDescription);

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Description'),
          content: TextField(
            controller: controller,
            maxLines: 5,
            decoration: const InputDecoration(
              labelText: 'Hotel Description',
              border: OutlineInputBorder(),
              alignLabelWithHint: true,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                final newDescription = controller.text.trim();

                try {
                  await _service.updateHotelDescription(
                    widget.hotel.id,
                    newDescription,
                  );

                  if (!mounted) return;

                  setState(() {
                    hotelDescription = newDescription;
                  });

                  Navigator.pop(context);
                } catch (e) {
                  if (!mounted) return;

                  ScaffoldMessenger.of(this.context).showSnackBar(
                    SnackBar(
                      content: Text('Failed to update description: $e'),
                    ),
                  );
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );

    controller.dispose();
  }

  Future<void> editHotelFacilities() async {
    List<String> selectedFacilities = List.from(hotelFacilities);

    await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Edit Facilities'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: availableFacilities.map((facility) {
                  return CheckboxListTile(
                    title: Text(facility),
                    value: selectedFacilities.contains(facility),
                    contentPadding: EdgeInsets.zero,
                    controlAffinity: ListTileControlAffinity.leading,
                    onChanged: (checked) {
                      setDialogState(() {
                        if (checked == true) {
                          selectedFacilities.add(facility);
                        } else {
                          selectedFacilities.remove(facility);
                        }
                      });
                    },
                  );
                }).toList(),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    try {
                      await _service.updateHotelFacilities(
                        widget.hotel.id,
                        selectedFacilities,
                      );

                      if (!mounted) return;

                      setState(() {
                        hotelFacilities = selectedFacilities;
                      });

                      Navigator.pop(context);
                    } catch (e) {
                      if (!mounted) return;

                      ScaffoldMessenger.of(this.context).showSnackBar(
                        SnackBar(
                          content: Text('Failed to update facilities: $e'),
                        ),
                      );
                    }
                  },
                  child: const Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> editAvailableRooms(HotelRooms room) async {
    final controller = TextEditingController(
      text: room.totalRooms.toString(),
    );

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit ${room.roomType} Rooms'),
          content: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Available Rooms',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                final newTotalRooms = int.tryParse(controller.text);

                if (newTotalRooms == null || newTotalRooms < 0) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please enter a valid room quantity'),
                    ),
                  );
                  return;
                }

                try {
                  await _service.updateAvailableRooms(
                    room.id,
                    newTotalRooms,
                  );

                  if (!mounted) return;

                  setState(() {
                    final index = hotelRooms.indexWhere(
                          (item) => item.id == room.id,
                    );

                    if (index != -1) {
                      hotelRooms[index] = HotelRooms(
                        id: room.id,
                        hotelId: room.hotelId,
                        roomType: room.roomType,
                        totalRooms: newTotalRooms,
                        pricePerNight: room.pricePerNight,
                        currency: room.currency,
                      );
                    }
                  });

                  Navigator.pop(context);
                } catch (e) {
                  if (!mounted) return;

                  ScaffoldMessenger.of(this.context).showSnackBar(
                    SnackBar(
                      content: Text('Failed to update available rooms: $e'),
                    ),
                  );
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );

    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        title: const Text(
          'Hotel Details',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // HOTEL IMAGE
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.network(
                widget.hotel.imageUrl,
                width: double.infinity,
                height: 220,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 220,
                    color: Colors.grey.shade200,
                    child: const Center(
                      child: Icon(
                        Icons.image_not_supported_outlined,
                        size: 45,
                        color: Colors.grey,
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 20),

            // HOTEL NAME AND STATUS
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: editHotelName,
                          child: Text(
                            hotelName,
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: editHotelName,
                        child: const Icon(
                          Icons.edit_outlined,
                          size: 19,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Icon(
                        Icons.star,
                        size: 19,
                        color: Colors.amber.shade700,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        '$hotelStars Stars',
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(width: 12),
                      GestureDetector(
                        onTap: editHotelStars,
                        child: const Icon(
                          Icons.edit_outlined,
                          size: 16,
                          color: Colors.grey,
                        ),
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: editHotelStatus,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 7,
                          ),
                          decoration: BoxDecoration(
                            color: hotelStatus.toLowerCase() == 'active'
                                ? Colors.green.shade50
                                : Colors.orange.shade50,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            hotelStatus,
                            style: TextStyle(
                              color: hotelStatus.toLowerCase() == 'active'
                                  ? Colors.green.shade700
                                  : Colors.orange.shade800,
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 18),

            // HOTEL INFORMATION
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Hotel Information',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 14),

                  GestureDetector(
                    onTap: editHotelAddress,
                    child: Row(
                      children: [
                        const Icon(Icons.location_on_outlined, color: Colors.grey),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Address',
                                  style: TextStyle(color: Colors.grey, fontSize: 12)),
                              const SizedBox(height: 3),
                              Text(hotelAddress),
                            ],
                          ),
                        ),
                        const Icon(Icons.edit_outlined, size: 17, color: Colors.grey),
                      ],
                    ),
                  ),

                  const Divider(height: 28),

                  GestureDetector(
                    onTap: editHotelCity,
                    child: Row(
                      children: [
                        const Icon(Icons.location_city_outlined, color: Colors.grey),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('City',
                                  style: TextStyle(color: Colors.grey, fontSize: 12)),
                              const SizedBox(height: 3),
                              Text(hotelCity),
                            ],
                          ),
                        ),
                        const Icon(Icons.edit_outlined, size: 17, color: Colors.grey),
                      ],
                    ),
                  ),

                  const Divider(height: 28),

                  GestureDetector(
                    onTap: editHotelCountry,
                    child: Row(
                      children: [
                        const Icon(Icons.public, color: Colors.grey),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Country',
                                  style: TextStyle(color: Colors.grey, fontSize: 12)),
                              const SizedBox(height: 3),
                              Text(hotelCountry),
                            ],
                          ),
                        ),
                        const Icon(Icons.edit_outlined, size: 17, color: Colors.grey),
                      ],
                    ),
                  ),

                  const Divider(height: 28),

                  GestureDetector(
                    onTap: editHotelCoordinates,
                    child: Row(
                      children: [
                        const Icon(Icons.map_outlined, color: Colors.grey),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Coordinates',
                                  style: TextStyle(color: Colors.grey, fontSize: 12)),
                              const SizedBox(height: 3),
                              Text('$hotelLatitude, $hotelLongitude'),
                            ],
                          ),
                        ),
                        const Icon(Icons.edit_outlined, size: 17, color: Colors.grey),
                      ],
                    ),
                  ),

                  const Divider(height: 28),

                  Row(
                    children: [
                      const Icon(Icons.person_outline, color: Colors.grey),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Hotel Owner',
                                style: TextStyle(color: Colors.grey, fontSize: 12)),
                            const SizedBox(height: 3),
                            Text(widget.hotel.ownerName ?? 'Not assigned'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 18),

            // DESCRIPTION
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Expanded(
                        child: Text(
                          'Description',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: editHotelDescription,
                        child: const Icon(
                          Icons.edit_outlined,
                          size: 19,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    hotelDescription.isEmpty
                        ? 'No description available'
                        : hotelDescription,
                    style: TextStyle(
                      color: Colors.grey.shade700,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 18),

            // FACILITIES
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Expanded(
                        child: Text(
                          'Facilities',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: editHotelFacilities,
                        child: const Icon(
                          Icons.edit_outlined,
                          size: 19,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  if (hotelFacilities.isEmpty)
                    const Text(
                      'No facilities selected',
                      style: TextStyle(color: Colors.grey),
                    )
                  else
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: hotelFacilities.map((facility) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 9,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF1F5F9),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            facility,
                            style: const TextStyle(fontSize: 13),
                          ),
                        );
                      }).toList(),
                    ),
                ],
              ),
            ),

            const SizedBox(height: 18),

            // ROOM TYPES
            const Text(
              'Room Types',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),

            ...hotelRooms.map((room) {
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.bed_outlined,
                        size: 25,
                        color: Colors.blueGrey,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            room.roomType,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            'Available Rooms: ${room.totalRooms}',
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            '${room.currency} ${room.pricePerNight}',
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () => editAvailableRooms(room),
                      icon: const Icon(
                        Icons.edit_outlined,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}