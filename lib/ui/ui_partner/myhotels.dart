import 'package:flutter/material.dart';
import 'package:hotelapps/models/hotels.dart';
import 'package:hotelapps/services/partnerhotel_service.dart';
import 'package:hotelapps/ui/ui_partner/addhotel.dart';

class MyHotelsPage extends StatefulWidget {
  const MyHotelsPage({super.key});

  @override
  State<MyHotelsPage> createState() => _MyHotelsPageState();
}

class _MyHotelsPageState extends State<MyHotelsPage> {
  final PartnerHotelService _service = PartnerHotelService();

  List<Hotels> _hotels = [];
  final TextEditingController _searchController = TextEditingController();

  String _searchQuery = '';
  String _selectedStatus = 'Active';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadHotels();
  }

  // @override
  // void dispose() {
  //   _searchController.dispose();
  //   super.dispose();
  // }

  Future<void> _loadHotels() async {
    try {
      final result = await _service.getPartnerHotels();

      if (!mounted) return;

      setState(() {
        _hotels = result;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load hotels: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final filteredHotels = _hotels.where((hotel) {
      final query = _searchQuery.toLowerCase();

      final matchesSearch =
          hotel.name.toLowerCase().contains(query) ||
              hotel.address.toLowerCase().contains(query) ||
              hotel.city.toLowerCase().contains(query) ||
              hotel.country.toLowerCase().contains(query);

      final matchesStatus = hotel.status == _selectedStatus;

      return matchesSearch && matchesStatus;
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF7F9F8),
      appBar: AppBar(
        title: const Text(
          'My Hotels',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF10B981),
        foregroundColor: Colors.white,
        elevation: 0,
      ),

      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Manage Your Properties',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                const Text(
                  'View and manage all your registered hotels.',
                  style: TextStyle(color: Colors.grey),
                ),

                const SizedBox(height: 18),

                // Search
                TextField(
                  controller: _searchController,
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'Search hotel name or location...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _searchController.clear();
                        setState(() {
                          _searchQuery = '';
                        });
                      },
                    )
                        : null,
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),

                const SizedBox(height: 16),
                // Status Filters
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _selectedStatus = 'Active';
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _selectedStatus == 'Active'
                              ? const Color(0xFF10B981)
                              : Colors.white,
                          foregroundColor: _selectedStatus == 'Active'
                              ? Colors.white
                              : Colors.black87,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 13),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text('Active'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _selectedStatus = 'Non-active';
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _selectedStatus == 'Non-active'
                              ? const Color(0xFF10B981)
                              : Colors.white,
                          foregroundColor: _selectedStatus == 'Non-active'
                              ? Colors.white
                              : Colors.black87,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 13),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text('Non-active'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _selectedStatus = 'Suspend';
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _selectedStatus == 'Suspend'
                              ? const Color(0xFF10B981)
                              : Colors.white,
                          foregroundColor: _selectedStatus == 'Suspend'
                              ? Colors.white
                              : Colors.black87,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 13),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text('Suspend'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Hotel Count
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${filteredHotels.length} Hotels',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                        const AddHotelPage(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('Add New Hotel'),
                  style: TextButton.styleFrom(
                    foregroundColor: const Color(0xFF10B981),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),

          // Hotel List
          Expanded(
            child: filteredHotels.isEmpty
                ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.apartment_rounded,
                    size: 55,
                    color: Colors.grey.shade400,
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'No hotels found',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    'Try changing your search or filter.',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            )
                : RefreshIndicator(
              onRefresh: _loadHotels,
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                itemCount: filteredHotels.length,
                itemBuilder: (context, index) {
                  final hotel = filteredHotels[index];

                  return Card(
                    color: Colors.white,
                    elevation: 1,
                    margin: const EdgeInsets.only(bottom: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(16),
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Hotel detail page will be connected next.',
                            ),
                          ),
                        );
                      },
                      leading: Container(
                        width: 52,
                        height: 52,
                        decoration: BoxDecoration(
                          color: const Color(0xFF10B981)
                              .withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.hotel_rounded,
                          color: Color(0xFF10B981),
                          size: 28,
                        ),
                      ),
                      title: Text(
                        hotel.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 6),
                        child: Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${hotel.city}, ${hotel.country}',
                            ),
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: hotel.status == 'Active'
                                    ? Colors.green.withOpacity(0.1)
                                    : Colors.orange.withOpacity(0.1),
                                borderRadius:
                                BorderRadius.circular(20),
                              ),
                              child: Text(
                                hotel.status,
                                style: TextStyle(
                                  color: hotel.status == 'Active'
                                      ? Colors.green
                                      : Colors.orange,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 11,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      trailing: const Icon(
                        Icons.chevron_right_rounded,
                        color: Colors.grey,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
