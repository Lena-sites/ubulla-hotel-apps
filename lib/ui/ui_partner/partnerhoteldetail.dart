
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:hotelapps/models/hotels.dart';
import 'package:hotelapps/models/hotelrooms.dart';
import 'package:hotelapps/services/partnerhotel_service.dart';

class PartnerHotelDetailPage extends StatefulWidget {
  final Hotels hotel;

  const PartnerHotelDetailPage({
    super.key,
    required this.hotel,
  });

  @override
  State<PartnerHotelDetailPage> createState() =>
      _PartnerHotelDetailPageState();
}

class _PartnerHotelDetailPageState
    extends State<PartnerHotelDetailPage> {
  final PartnerHotelService _service = PartnerHotelService();

  static const Color primaryColor = Color(0xFF10B981);

  late String hotelName;
  late String hotelAddress;
  late String hotelCity;
  late String hotelCountry;
  late double hotelLatitude;
  late double hotelLongitude;
  late int hotelStars;
  late String hotelDescription;
  late String hotelImageUrl;
  late List<String> hotelFacilities;
  late List<HotelRooms> hotelRooms;

  bool isUploadingImage = false;

  final List<String> availableFacilities = [
    'Swimming Pool',
    'WiFi',
    'Restaurant',
    'Parking',
    'Meeting Room',
    'Fitness Center',
  ];

  @override
  void initState() {
    super.initState();

    hotelName = widget.hotel.name;
    hotelAddress = widget.hotel.address;
    hotelCity = widget.hotel.city;
    hotelCountry = widget.hotel.country;
    hotelLatitude = widget.hotel.latitude;
    hotelLongitude = widget.hotel.longitude;
    hotelStars = widget.hotel.hotelStars ?? 3;
    hotelDescription = widget.hotel.details;
    hotelImageUrl = widget.hotel.imageUrl;
    hotelFacilities = List<String>.from(widget.hotel.facilities);
    hotelRooms = List<HotelRooms>.from(widget.hotel.rooms);
  }

  // Menyimpan perubahan hotel ke Supabase
  Future<void> saveHotelChanges({
    String? name,
    String? address,
    String? city,
    String? country,
    double? latitude,
    double? longitude,
    int? stars,
    String? description,
    String? imageUrl,
    List<String>? facilities,
    List<HotelRooms>? rooms,
  }) async {
    final newRooms = rooms ?? hotelRooms;

    try {
      await _service.updatePartnerHotel(
        hotelId: widget.hotel.id,
        name: name ?? hotelName,
        address: address ?? hotelAddress,
        city: city ?? hotelCity,
        country: country ?? hotelCountry,
        latitude: latitude ?? hotelLatitude,
        longitude: longitude ?? hotelLongitude,
        hotelStars: stars ?? hotelStars,
        description: description ?? hotelDescription,
        imageUrl: imageUrl ?? hotelImageUrl,
        facilities: facilities ?? hotelFacilities,
        rooms: newRooms.map((room) {
          return {
            'room_type': room.roomType,
            'total_rooms': room.totalRooms,
            'price_per_night': room.pricePerNight,
          };
        }).toList(),
      );

      if (!mounted) return;

      setState(() {
        hotelName = name ?? hotelName;
        hotelAddress = address ?? hotelAddress;
        hotelCity = city ?? hotelCity;
        hotelCountry = country ?? hotelCountry;
        hotelLatitude = latitude ?? hotelLatitude;
        hotelLongitude = longitude ?? hotelLongitude;
        hotelStars = stars ?? hotelStars;
        hotelDescription = description ?? hotelDescription;
        hotelImageUrl = imageUrl ?? hotelImageUrl;
        hotelFacilities = facilities ?? hotelFacilities;
        hotelRooms = newRooms;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Hotel information updated successfully!'),
          backgroundColor: primaryColor,
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update hotel: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // Dialog edit text
  Future<void> editText({
    required String title,
    required String label,
    required String currentValue,
    required Function(String) onSave,
    int maxLines = 1,
  }) async {
    final controller = TextEditingController(text: currentValue);

    await showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(title),
          content: TextField(
            controller: controller,
            maxLines: maxLines,
            decoration: InputDecoration(
              labelText: label,
              border: const OutlineInputBorder(),
              alignLabelWithHint: maxLines > 1,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                final value = controller.text.trim();

                if (value.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('This field cannot be empty'),
                    ),
                  );
                  return;
                }

                Navigator.pop(dialogContext);
                onSave(value);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  // Edit nama hotel
  Future<void> editHotelName() async {
    await editText(
      title: 'Edit Hotel Name',
      label: 'Hotel Name',
      currentValue: hotelName,
      onSave: (value) {
        saveHotelChanges(name: value);
      },
    );
  }

  // Edit alamat
  Future<void> editHotelAddress() async {
    await editText(
      title: 'Edit Hotel Address',
      label: 'Address',
      currentValue: hotelAddress,
      maxLines: 2,
      onSave: (value) {
        saveHotelChanges(address: value);
      },
    );
  }

  // Edit kota
  Future<void> editHotelCity() async {
    await editText(
      title: 'Edit Hotel City',
      label: 'City',
      currentValue: hotelCity,
      onSave: (value) {
        saveHotelChanges(city: value);
      },
    );
  }

  // Edit negara
  Future<void> editHotelCountry() async {
    await editText(
      title: 'Edit Hotel Country',
      label: 'Country',
      currentValue: hotelCountry,
      onSave: (value) {
        saveHotelChanges(country: value);
      },
    );
  }

  // Edit koordinat
  Future<void> editHotelCoordinates() async {
    final latitudeController = TextEditingController(
      text: hotelLatitude.toString(),
    );

    final longitudeController = TextEditingController(
      text: hotelLongitude.toString(),
    );

    await showDialog(
      context: context,
      builder: (dialogContext) {
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
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
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
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please enter valid coordinates'),
                    ),
                  );
                  return;
                }

                Navigator.pop(dialogContext);

                saveHotelChanges(
                  latitude: latitude,
                  longitude: longitude,
                );
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  // Edit jumlah bintang
  Future<void> editHotelStars() async {
    int selectedStars = hotelStars;

    await showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Edit Hotel Stars'),
              content: DropdownButtonFormField<int>(
                value: selectedStars,
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
                  onPressed: () => Navigator.pop(dialogContext),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.pop(dialogContext);
                    saveHotelChanges(stars: selectedStars);
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

  // Edit deskripsi
  Future<void> editHotelDescription() async {
    await editText(
      title: 'Edit Description',
      label: 'Hotel Description',
      currentValue: hotelDescription,
      maxLines: 5,
      onSave: (value) {
        saveHotelChanges(description: value);
      },
    );
  }

  // Edit fasilitas
  Future<void> editHotelFacilities() async {
    List<String> selectedFacilities = List.from(hotelFacilities);

    await showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Edit Hotel Facilities'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: availableFacilities.map((facility) {
                    return CheckboxListTile(
                      title: Text(facility),
                      value: selectedFacilities.contains(facility),
                      contentPadding: EdgeInsets.zero,
                      activeColor: primaryColor,
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
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.pop(dialogContext);
                    saveHotelChanges(facilities: selectedFacilities);
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

  // Edit jumlah kamar dan harga
  Future<void> editRoom(HotelRooms room) async {
    final quantityController = TextEditingController(
      text: room.totalRooms.toString(),
    );

    final priceController = TextEditingController(
      text: room.pricePerNight.toString(),
    );

    await showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text('Edit ${room.roomType} Room'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: quantityController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Total Rooms',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: priceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Price per Night (IDR)',
                  prefixText: 'Rp ',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                final quantity = int.tryParse(
                  quantityController.text.trim(),
                );

                final price = int.tryParse(
                  priceController.text.trim(),
                );

                if (quantity == null ||
                    price == null ||
                    quantity < 0 ||
                    price < 0) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please enter valid room quantity and price'),
                    ),
                  );
                  return;
                }

                final updatedRooms = hotelRooms.map((item) {
                  if (item.id == room.id) {
                    return HotelRooms(
                      id: item.id,
                      hotelId: item.hotelId,
                      roomType: item.roomType,
                      totalRooms: quantity,
                      pricePerNight: price,
                      currency: 'IDR',
                    );
                  }

                  return item;
                }).toList();

                Navigator.pop(dialogContext);

                saveHotelChanges(rooms: updatedRooms);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  // Ganti foto hotel
  Future<void> editHotelImage() async {
    final XFile? image = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (image == null) return;

    setState(() {
      isUploadingImage = true;
    });

    try {
      final supabase = Supabase.instance.client;
      final imageBytes = await image.readAsBytes();

      final fileName =
          '${DateTime.now().millisecondsSinceEpoch}_${image.name}';

      await supabase.storage
          .from('hotel-images')
          .uploadBinary(
        fileName,
        imageBytes,
        fileOptions: FileOptions(
          contentType: image.mimeType ?? 'image/jpeg',
          upsert: false,
        ),
      );

      final imageUrl = supabase.storage
          .from('hotel-images')
          .getPublicUrl(fileName);

      await saveHotelChanges(imageUrl: imageUrl);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to upload hotel image: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          isUploadingImage = false;
        });
      }
    }
  }

  // Widget tombol pensil
  Widget editButton(VoidCallback onPressed) {
    return IconButton(
      onPressed: onPressed,
      icon: const Icon(
        Icons.edit_outlined,
        size: 19,
        color: Colors.grey,
      ),
      tooltip: 'Edit',
    );
  }

  // Widget informasi hotel
  Widget informationTile({
    required IconData icon,
    required String title,
    required String value,
    required VoidCallback onEdit,
  }) {
    return Row(
      children: [
        Icon(icon, color: Colors.grey, size: 22),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        editButton(onEdit),
      ],
    );
  }

  // Widget judul section
  Widget sectionTitle(String title, VoidCallback onEdit) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        editButton(onEdit),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9F8),
      appBar: AppBar(
        title: const Text(
          'Hotel Details',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // HOTEL IMAGE
            Stack(
              children: [
                Image.network(
                  hotelImageUrl,
                  width: double.infinity,
                  height: 230,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: double.infinity,
                      height: 230,
                      color: Colors.grey.shade200,
                      child: const Icon(
                        Icons.hotel,
                        size: 65,
                        color: Colors.grey,
                      ),
                    );
                  },
                ),
                Positioned(
                  right: 16,
                  bottom: 16,
                  child: ElevatedButton.icon(
                    onPressed: isUploadingImage ? null : editHotelImage,
                    icon: isUploadingImage
                        ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                        : const Icon(Icons.edit_outlined, size: 18),
                    label: Text(
                      isUploadingImage ? 'Uploading...' : 'Change Photo',
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: primaryColor,
                    ),
                  ),
                ),
              ],
            ),

            Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // HOTEL NAME
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          hotelName,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      editButton(editHotelName),
                    ],
                  ),

                  const SizedBox(height: 8),

                  Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        color: primaryColor,
                        size: 19,
                      ),
                      const SizedBox(width: 5),
                      Expanded(
                        child: Text(
                          '$hotelCity, $hotelCountry',
                          style: TextStyle(
                            color: Colors.grey.shade700,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 14),

                  // STARS AND STATUS
                  Row(
                    children: [
                      const Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        '$hotelStars Star Hotel',
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      editButton(editHotelStars),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: widget.hotel.status == 'Active'
                              ? Colors.green.withOpacity(0.1)
                              : Colors.orange.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          widget.hotel.status,
                          style: TextStyle(
                            color: widget.hotel.status == 'Active'
                                ? Colors.green
                                : Colors.orange,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

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
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),

                        informationTile(
                          icon: Icons.location_on_outlined,
                          title: 'Address',
                          value: hotelAddress,
                          onEdit: editHotelAddress,
                        ),

                        const Divider(height: 28),

                        informationTile(
                          icon: Icons.location_city_outlined,
                          title: 'City',
                          value: hotelCity,
                          onEdit: editHotelCity,
                        ),

                        const Divider(height: 28),

                        informationTile(
                          icon: Icons.public,
                          title: 'Country',
                          value: hotelCountry,
                          onEdit: editHotelCountry,
                        ),

                        const Divider(height: 28),

                        informationTile(
                          icon: Icons.map_outlined,
                          title: 'Coordinates',
                          value: '$hotelLatitude, $hotelLongitude',
                          onEdit: editHotelCoordinates,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

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
                        sectionTitle(
                          'About Hotel',
                          editHotelDescription,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          hotelDescription.isNotEmpty
                              ? hotelDescription
                              : 'No description available.',
                          style: TextStyle(
                            color: Colors.grey.shade700,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

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
                        sectionTitle(
                          'Hotel Facilities',
                          editHotelFacilities,
                        ),
                        const SizedBox(height: 14),

                        if (hotelFacilities.isEmpty)
                          const Text('No facilities added.')
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
                                  color: primaryColor.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  facility,
                                  style: const TextStyle(
                                    color: primaryColor,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // ROOM DETAILS
                  const Text(
                    'Room Details & Pricing',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),

                  ...hotelRooms.map((room) {
                    final available = room.totalRooms > 0;

                    return Card(
                      color: Colors.white,
                      elevation: 1,
                      margin: const EdgeInsets.only(bottom: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Icons.bed_outlined,
                                  color: primaryColor,
                                  size: 23,
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    room.roomType,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Text(
                                  available ? 'Available' : 'Unavailable',
                                  style: TextStyle(
                                    color: available
                                        ? Colors.green
                                        : Colors.red,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                                editButton(() => editRoom(room)),
                              ],
                            ),

                            const SizedBox(height: 12),

                            Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Total Rooms',
                                  style: TextStyle(
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                                Text(
                                  '${room.totalRooms} Rooms',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 8),

                            Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Price per Night',
                                  style: TextStyle(
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                                Text(
                                  'Rp ${room.pricePerNight}',
                                  style: const TextStyle(
                                    color: primaryColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  }),

                  const SizedBox(height: 24),

                  // HOTEL CATEGORY
                  const Text(
                    'Hotel Category',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),

                  Text(
                    hotelStars == 5 ? 'Recommended' : 'New',
                    style: const TextStyle(
                      color: primaryColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 30),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}