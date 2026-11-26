import 'package:flutter/material.dart';
import 'package:hotelapps/models/customers.dart';
import 'package:hotelapps/services/customermanagement_service.dart';

class CustomerManagementPage extends StatefulWidget {
  const CustomerManagementPage({super.key});

  @override
  State<CustomerManagementPage> createState() =>
      _CustomerManagementPageState();
}

class _CustomerManagementPageState extends State<CustomerManagementPage> {
  final CustomerManagementService _service =
  CustomerManagementService();

  List<Customers> _customers = [];
  Map<String, bool> _customerStatus = {};
  final TextEditingController _searchController =
  TextEditingController();

  String _searchQuery = '';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCustomers();
  }

  Future<void> _loadCustomers() async {
    try {
      final result = await _service.getAllCustomers();
      final Map<String, bool> status = {};

      for (final customer in result) {
        try {
          status[customer.id] =
          await _service.getCustomerStatus(customer.id);
        } catch (e) {
          debugPrint(
            'Failed to get status for ${customer.email}: $e',
          );
        }
      }

      if (!mounted) return;

      setState(() {
        _customers = result;
        _customerStatus = status;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to load customers: $e'),
        ),
      );
    }
  }

  Future<void> _deactivateCustomer(Customers customer) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Deactivate Customer'),
        content: Text(
          'Are you sure you want to deactivate ${customer.name}\'s account?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Deactivate'),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    try {
      await _service.manageCustomerAccount(
        customerId: customer.id,
        action: 'deactivate',
      );
      setState(() {
        _customerStatus[customer.id] = false;
      });

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Customer account deactivated successfully'),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to deactivate customer: $e')),
      );
    }
  }

  Future<void> _reactivateCustomer(Customers customer) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reactivate Customer'),
        content: Text(
            'Are you sure you want to reactivate this account?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF10A05A),
              foregroundColor: Colors.white,
            ),
            child: const Text('Reactivate'),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    try {
      await _service.manageCustomerAccount(
        customerId: customer.id,
        action: 'reactivate',
      );

      if (!mounted) return;

      setState(() {
        _customerStatus[customer.id] = true;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Customer account reactivated successfully'),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to reactivate customer: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final filteredCustomers = _customers.where((customer) {
      final query = _searchQuery.toLowerCase();

      return customer.name.toLowerCase().contains(query) ||
          customer.email.toLowerCase().contains(query);
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Customer Management'),
        backgroundColor: const Color(0xFF10A05A),
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
              decoration: InputDecoration(
                hintText: 'Search customer name or email...',
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
          Expanded(
            child: filteredCustomers.isEmpty
                ? const Center(
              child: Text('Customer not found'),
            )
                : ListView.builder(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
              ),
              itemCount: filteredCustomers.length,
              itemBuilder: (context, index) {
                final customer =
                filteredCustomers[index];

                return Card(
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor:
                      const Color(0xFF10A05A)
                          .withOpacity(0.1),
                      backgroundImage:
                      customer.avatarUrl != null &&
                          customer.avatarUrl!.isNotEmpty
                          ? NetworkImage(customer.avatarUrl!)
                          : null,
                      onBackgroundImageError: (exception, stackTrace) {},
                      child: customer.avatarUrl == null ||
                          customer.avatarUrl!.isEmpty
                          ? const Icon(
                        Icons.person,
                        color: Color(0xFF10A05A),
                      )
                          : null,
                    ),
                    title: Text(
                      customer.name.isEmpty
                          ? 'Unnamed Customer'
                          : customer.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(customer.email),
                    trailing: _customerStatus.containsKey(customer.id)
                        ? _customerStatus[customer.id]!
                        ? IconButton(
                      icon: const Icon(
                        Icons.block,
                        color: Colors.red,
                      ),
                      tooltip: 'Deactivate Customer',
                      onPressed: () => _deactivateCustomer(customer),
                    )
                        : IconButton(
                      icon: const Icon(
                        Icons.check_circle,
                        color: Color(0xFF10A05A),
                      ),
                      tooltip: 'Reactivate Customer',
                      onPressed: () => _reactivateCustomer(customer),
                    )
                        : const SizedBox(
                      width: 48,
                      child: Center(
                        child: SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      ),
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
