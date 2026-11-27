
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:hotelapps/services/partnerhotel_service.dart';

class AddHotelPage extends StatefulWidget {
  const AddHotelPage({super.key});

  @override
  State<AddHotelPage> createState() => _AddHotelPageState();
}

class _AddHotelPageState extends State<AddHotelPage> {
  final formKey = GlobalKey<FormState>();

  // Basic Information
  final hotelNameController = TextEditingController();
  final descriptionController = TextEditingController();

  // Location Details
  final addressController = TextEditingController();
  final cityController = TextEditingController();
  final countryController = TextEditingController();
  final latitudeController = TextEditingController();
  final longitudeController = TextEditingController();

  // Hotel Information
  int selectedStars = 3;

  // Hotel Facilities
  final List<String> availableFacilities = [
    'Swimming Pool',
    'WiFi',
    'Restaurant',
    'Parking',
    'Meeting Room',
    'Fitness Center',
  ];

  final List<String> selectedFacilities = [];

  // Room Availability
  bool standardAvailable = false;
  bool deluxeAvailable = false;
  bool suiteAvailable = false;

  // Room Quantity
  final standardRoomsController = TextEditingController();
  final deluxeRoomsController = TextEditingController();
  final suiteRoomsController = TextEditingController();

  // Room Price
  final standardPriceController = TextEditingController();
  final deluxePriceController = TextEditingController();
  final suitePriceController = TextEditingController();

  // Hotel Image
  String? uploadedImageUrl;
  bool isUploadingImage = false;

  // Upload Hotel Image
  Future<void> pickHotelImage() async {
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

      uploadedImageUrl = supabase.storage
          .from('hotel-images')
          .getPublicUrl(fileName);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Hotel image uploaded successfully!'),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to upload image: $e'),
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

  // Save Hotel
  Future<void> saveHotel() async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    if (uploadedImageUrl == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please upload a hotel image first'),
        ),
      );
      return;
    }

    if (isUploadingImage) {
      return;
    }

    try {
      await PartnerHotelService().addPartnerHotel(
        name: hotelNameController.text.trim(),
        address: addressController.text.trim(),
        city: cityController.text.trim(),
        country: countryController.text.trim(),
        latitude: double.parse(latitudeController.text.trim()),
        longitude: double.parse(longitudeController.text.trim()),
        hotelStars: selectedStars,
        description: descriptionController.text.trim(),
        imageUrl: uploadedImageUrl!,
        facilities: selectedFacilities,

        // Room Data
        rooms: [
          {
            'room_type': 'Standard',
            'total_rooms': standardAvailable
                ? int.parse(standardRoomsController.text.trim())
                : 0,
            'price_per_night': standardAvailable
                ? double.parse(standardPriceController.text.trim())
                : 0,
          },
          {
            'room_type': 'Deluxe',
            'total_rooms': deluxeAvailable
                ? int.parse(deluxeRoomsController.text.trim())
                : 0,
            'price_per_night': deluxeAvailable
                ? double.parse(deluxePriceController.text.trim())
                : 0,
          },
          {
            'room_type': 'Suite',
            'total_rooms': suiteAvailable
                ? int.parse(suiteRoomsController.text.trim())
                : 0,
            'price_per_night': suiteAvailable
                ? double.parse(suitePriceController.text.trim())
                : 0,
          },
        ],
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Hotel added successfully!'),
        ),
      );

      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to add hotel: $e'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Hotel'),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // =====================================
              // BASIC INFORMATION
              // =====================================

              const Text(
                'Basic Information',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 6),

              Text(
                'Tell us about your property.',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                ),
              ),

              const SizedBox(height: 24),

              const Text(
                'Hotel Name',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),

              const SizedBox(height: 8),

              TextFormField(
                controller: hotelNameController,
                decoration: InputDecoration(
                  hintText: 'Enter hotel name',
                  prefixIcon: const Icon(Icons.hotel_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Hotel name is required';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 20),

              const Text(
                'Hotel Stars',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),

              const SizedBox(height: 8),

              DropdownButtonFormField<int>(
                value: selectedStars,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.star_outline),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
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
                    setState(() {
                      selectedStars = value;
                    });
                  }
                },
              ),

              const SizedBox(height: 20),

              const Text(
                'Hotel Description',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),

              const SizedBox(height: 8),

              TextFormField(
                controller: descriptionController,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText:
                  'Describe your hotel, its atmosphere, and services...',
                  alignLabelWithHint: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Hotel description is required';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 32),
              const Divider(),
              const SizedBox(height: 20),

              // =====================================
              // LOCATION DETAILS
              // =====================================

              const Text(
                'Location Details',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 6),

              Text(
                'Provide the exact location of your property.',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                ),
              ),

              const SizedBox(height: 24),

              const Text(
                'Full Address',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),

              const SizedBox(height: 8),

              TextFormField(
                controller: addressController,
                maxLines: 2,
                decoration: InputDecoration(
                  hintText: 'Enter complete hotel address',
                  prefixIcon: const Icon(Icons.location_on_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Hotel address is required';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 20),

              const Text(
                'City',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),

              const SizedBox(height: 8),

              TextFormField(
                controller: cityController,
                decoration: InputDecoration(
                  hintText: 'Enter city',
                  prefixIcon: const Icon(Icons.location_city_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'City is required';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 20),

              const Text(
                'Country',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),

              const SizedBox(height: 8),

              TextFormField(
                controller: countryController,
                decoration: InputDecoration(
                  hintText: 'Enter country',
                  prefixIcon: const Icon(Icons.public),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Country is required';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 20),

              const Text(
                'Coordinates',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),

              const SizedBox(height: 6),

              Text(
                'Enter the geographical coordinates of your hotel.',
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey.shade600,
                ),
              ),

              const SizedBox(height: 12),

              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: latitudeController,
                      keyboardType:
                      const TextInputType.numberWithOptions(
                        decimal: true,
                        signed: true,
                      ),
                      decoration: InputDecoration(
                        labelText: 'Latitude',
                        hintText: '-6.200000',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Required';
                        }

                        if (double.tryParse(value.trim()) == null) {
                          return 'Invalid number';
                        }

                        final latitude =
                        double.parse(value.trim());

                        if (latitude < -90 || latitude > 90) {
                          return 'Invalid latitude';
                        }

                        return null;
                      },
                    ),
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: TextFormField(
                      controller: longitudeController,
                      keyboardType:
                      const TextInputType.numberWithOptions(
                        decimal: true,
                        signed: true,
                      ),
                      decoration: InputDecoration(
                        labelText: 'Longitude',
                        hintText: '106.816666',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Required';
                        }

                        if (double.tryParse(value.trim()) == null) {
                          return 'Invalid number';
                        }

                        final longitude =
                        double.parse(value.trim());

                        if (longitude < -180 || longitude > 180) {
                          return 'Invalid longitude';
                        }

                        return null;
                      },
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 32),
              const Divider(),
              const SizedBox(height: 20),

              // =====================================
              // HOTEL IMAGES
              // =====================================

              const Text(
                'Hotel Images',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 6),

              Text(
                'Upload a photo that represents your hotel.',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                ),
              ),

              const SizedBox(height: 20),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.grey.shade300,
                  ),
                ),
                child: Column(
                  children: [
                    if (uploadedImageUrl != null) ...[
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          uploadedImageUrl!,
                          width: double.infinity,
                          height: 110,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              height: 200,
                              color: Colors.grey.shade200,
                              child: const Center(
                                child: Icon(
                                  Icons.broken_image,
                                  size: 40,
                                ),
                              ),
                            );
                          },
                        ),
                      ),

                      const SizedBox(height: 12),

                      const Text(
                        'Image uploaded successfully!',
                        style: TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ] else ...[
                      const Icon(
                        Icons.cloud_upload_outlined,
                        size: 40,
                        color: Colors.green,
                      ),

                      const SizedBox(height: 12),

                      const Text(
                        'Upload Hotel Photo',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        ),
                      ),

                      const SizedBox(height: 6),

                      Text(
                        'Choose an image from your gallery',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],

                    const SizedBox(height: 16),

                    OutlinedButton.icon(
                      onPressed:
                      isUploadingImage ? null : pickHotelImage,
                      icon: isUploadingImage
                          ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      )
                          : const Icon(
                        Icons.add_photo_alternate_outlined,
                      ),
                      label: Text(
                        isUploadingImage
                            ? 'Uploading...'
                            : 'Choose Image',
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),
              const Divider(),
              const SizedBox(height: 20),

              // =====================================
              // HOTEL FACILITIES
              // =====================================

              const Text(
                'Hotel Facilities',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 6),

              Text(
                'Select the facilities available at your property.',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                ),
              ),

              const SizedBox(height: 20),

              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: availableFacilities.map((facility) {
                  final isSelected =
                  selectedFacilities.contains(facility);

                  return FilterChip(
                    label: Text(facility),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        if (selected) {
                          selectedFacilities.add(facility);
                        } else {
                          selectedFacilities.remove(facility);
                        }
                      });
                    },
                    selectedColor: Colors.green.shade100,
                    checkmarkColor: Colors.green.shade800,
                    side: BorderSide(
                      color: isSelected
                          ? Colors.green
                          : Colors.grey.shade300,
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: 32),
              const Divider(),
              const SizedBox(height: 20),

              // =====================================
              // ROOM DETAILS & PRICING
              // =====================================

              const Text(
                'Room Details & Pricing',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 6),

              Text(
                'Select available room types and enter their quantity and price.',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                ),
              ),

              const SizedBox(height: 20),

              // STANDARD ROOM

              CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text(
                  'Standard Room',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                value: standardAvailable,
                activeColor: Colors.green,
                onChanged: (value) {
                  setState(() {
                    standardAvailable = value!;
                  });
                },
              ),

              if (standardAvailable) ...[
                TextFormField(
                  controller: standardRoomsController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Total Standard Rooms',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (standardAvailable &&
                        (value == null ||
                            int.tryParse(value) == null ||
                            int.parse(value) <= 0)) {
                      return 'Enter a valid room quantity';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 12),

                TextFormField(
                  controller: standardPriceController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Price per Night (IDR)',
                    prefixText: 'Rp ',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (standardAvailable &&
                        (value == null ||
                            double.tryParse(value) == null ||
                            double.parse(value) <= 0)) {
                      return 'Enter a valid room price';
                    }
                    return null;
                  },
                ),
              ],

              const SizedBox(height: 16),

              // DELUXE ROOM

              CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text(
                  'Deluxe Room',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                value: deluxeAvailable,
                activeColor: Colors.green,
                onChanged: (value) {
                  setState(() {
                    deluxeAvailable = value!;
                  });
                },
              ),

              if (deluxeAvailable) ...[
                TextFormField(
                  controller: deluxeRoomsController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Total Deluxe Rooms',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (deluxeAvailable &&
                        (value == null ||
                            int.tryParse(value) == null ||
                            int.parse(value) <= 0)) {
                      return 'Enter a valid room quantity';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 12),

                TextFormField(
                  controller: deluxePriceController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Price per Night (IDR)',
                    prefixText: 'Rp ',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (deluxeAvailable &&
                        (value == null ||
                            double.tryParse(value) == null ||
                            double.parse(value) <= 0)) {
                      return 'Enter a valid room price';
                    }
                    return null;
                  },
                ),
              ],

              const SizedBox(height: 16),

              // SUITE ROOM

              CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text(
                  'Suite Room',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                value: suiteAvailable,
                activeColor: Colors.green,
                onChanged: (value) {
                  setState(() {
                    suiteAvailable = value!;
                  });
                },
              ),

              if (suiteAvailable) ...[
                TextFormField(
                  controller: suiteRoomsController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Total Suite Rooms',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (suiteAvailable &&
                        (value == null ||
                            int.tryParse(value) == null ||
                            int.parse(value) <= 0)) {
                      return 'Enter a valid room quantity';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 12),

                TextFormField(
                  controller: suitePriceController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Price per Night (IDR)',
                    prefixText: 'Rp ',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (suiteAvailable &&
                        (value == null ||
                            double.tryParse(value) == null ||
                            double.parse(value) <= 0)) {
                      return 'Enter a valid room price';
                    }
                    return null;
                  },
                ),
              ],

              const SizedBox(height: 32),

              // =====================================
              // SAVE HOTEL BUTTON
              // =====================================

              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  onPressed: saveHotel,
                  icon: const Icon(Icons.save_outlined),
                  label: const Text(
                    'Save Hotel',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
