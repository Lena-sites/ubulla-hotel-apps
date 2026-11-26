import 'package:flutter/material.dart';
import 'package:hotelapps/models/hotels.dart';
import 'package:hotelapps/services/hotelmanagement_service.dart';
import 'package:hotelapps/ui/ui_admin/hoteldetail.dart';

class HotelManagementPage extends StatefulWidget {
  const HotelManagementPage({super.key});

  @override
  State<HotelManagementPage> createState() => _HotelManagementPageState();
}

class _HotelManagementPageState extends State<HotelManagementPage> {
  final HotelManagementService _service =
  HotelManagementService();

  List<Hotels> _hotels = [];
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _selectedStatus = 'All';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadHotels();
  }

  Future<void> _loadHotels() async {
    try {
      final result = await _service.getAllHotels();

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
        SnackBar(content: Text('Gagal mengambil data hotel: $e')),
      );
    }
  }

  Future<void> _deleteHotel(Hotels hotel) async {
    //ini handling error dari supabase nya kalau misalnya hotel tersebut sudah bertransaksi (integritas tabel transaksi)
    try {
      final hasTransactions = await _service.hasTransactions(hotel.id);

      if (!mounted) return;

      if (hasTransactions) {
        await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Cannot Delete Hotel'),
            content: const Text(
              'This hotel has transaction history and cannot be deleted. '
                  'Please change its status to Non-active instead.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
        );

        return;
      }
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to check hotel transactions: $e'),
        ),
      );

      return;
    }
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Hotel'),
        content: Text(
          'Are you sure you want to delete "${hotel.name}"?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    try {
      await _service.deleteHotel(hotel.id);

      if (!mounted) return;

      setState(() {
        _hotels.removeWhere((item) => item.id == hotel.id);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Hotel deleted successfully'),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to delete hotel: $e'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    //Filter hotel berdasarkan nama
    final filteredHotels = _hotels.where((hotel) {
      final query = _searchQuery.toLowerCase();

      final matchesSearch =
          hotel.name.toLowerCase().contains(query) ||
              hotel.address.toLowerCase().contains(query) ||
              hotel.city.toLowerCase().contains(query) ||
              hotel.country.toLowerCase().contains(query) ||
              (hotel.ownerName ?? '').toLowerCase().contains(query);

      final matchesStatus = _selectedStatus == 'All' ||
          hotel.status == _selectedStatus;

      return matchesSearch && matchesStatus;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Hotel Management'),
        backgroundColor: const Color(0xFF10A05A),
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
              decoration: InputDecoration(
                hintText: 'Cari nama hotel...',
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
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: DropdownButtonFormField<String>(
              value: _selectedStatus,
              decoration: InputDecoration(
                labelText: 'Filter by Status',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              items: const [
                DropdownMenuItem(value: 'All', child: Text('All Status')),
                DropdownMenuItem(value: 'Active', child: Text('Active')),
                DropdownMenuItem(value: 'Non-active', child: Text('Non-active')),
                DropdownMenuItem(value: 'Suspend', child: Text('Suspend')),
              ],
              onChanged: (value) {
                setState(() {
                  _selectedStatus = value!;
                });
              },
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: filteredHotels.isEmpty
                ? const Center(child: Text('Hotel tidak ditemukan'))
                : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: filteredHotels.length,
              itemBuilder: (context, index) {
                final hotel = filteredHotels[index];

                return Card(
                  child: ListTile(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HotelDetailPage(
                            hotel: hotel,
                          ),
                        ),
                      );
                    },
                    title: Text(
                      hotel.name,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${hotel.city}, ${hotel.country}'),
                        Text('Owner: ${hotel.ownerName ?? 'Not assigned'}'),
                        Container(
                          margin: const EdgeInsets.only(top: 6),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: hotel.status == 'Active'
                                ? Colors.green.withOpacity(0.1)
                                : hotel.status == 'Suspend'
                                ? Colors.red.withOpacity(0.1)
                                : Colors.orange.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            hotel.status,
                            style: TextStyle(
                              color: hotel.status == 'Active'
                                  ? Colors.green
                                  : hotel.status == 'Suspend'
                                  ? Colors.red
                                  : Colors.orange,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                    trailing: IconButton(
                      icon: const Icon(
                        Icons.delete_outline,
                        color: Colors.red,
                      ),
                      tooltip: 'Delete Hotel',
                      onPressed: () => _deleteHotel(hotel),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
