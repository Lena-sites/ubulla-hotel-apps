import 'package:flutter/material.dart';
import 'package:hotelapps/models/partnerapplications.dart';
import 'package:hotelapps/services/partnerapproval_service.dart';

class PartnerApprovalPage extends StatefulWidget {
  const PartnerApprovalPage({super.key});

  @override
  State<PartnerApprovalPage> createState() =>
      _PartnerApprovalPageState();
}

class _PartnerApprovalPageState extends State<PartnerApprovalPage> {
  final PartnerApprovalService _service = PartnerApprovalService();

  List<PartnerApplications> _applications = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadApplications();
  }

  Future<void> _loadApplications() async {
    try {
      final result = await _service.getAllApplications();

      if (!mounted) return;

      setState(() {
        _applications = result;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to load applications: $e'),
        ),
      );
    }
  }


  Future<void> _reviewApplication(
      PartnerApplications application,
      String status,
      ) async {
    final isApproved = status == 'approved';

    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          isApproved ? 'Approve Application' : 'Reject Application',
        ),
        content: Text(
          'Are you sure you want to ${isApproved ? 'approve' : 'reject'} '
              '${application.hotelName} application?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor:
              isApproved ? const Color(0xFF10A05A) : Colors.red,
              foregroundColor: Colors.white,
            ),
            child: Text(isApproved ? 'Approve' : 'Reject'),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    try {
      await _service.updateApplicationStatus(
        applicationId: application.id,
        status: status,
      );

      if (!mounted) return;

      await _loadApplications();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            isApproved
                ? 'Application approved successfully'
                : 'Application rejected successfully',
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to review application: $e'),
        ),
      );
    }
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'approved':
        return Colors.green;
      case 'rejected':
        return Colors.red;
      default:
        return Colors.orange;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Partner Approval'),
        backgroundColor: const Color(0xFF10A05A),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: _loadApplications,
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
        child: CircularProgressIndicator(),
      )
          : _applications.isEmpty
          ? const Center(
        child: Text('No partner applications yet'),
      )
          : RefreshIndicator(
        onRefresh: _loadApplications,
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: _applications.length,
          itemBuilder: (context, index) {
            final application = _applications[index];
            final isPending =
                application.status == 'pending';

            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            application.hotelName,
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: _statusColor(
                              application.status,
                            ).withOpacity(0.12),
                            borderRadius:
                            BorderRadius.circular(20),
                          ),
                          child: Text(
                            application.status.toUpperCase(),
                            style: TextStyle(
                              color: _statusColor(
                                application.status,
                              ),
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.location_on_outlined,
                          size: 18,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            application.hotelAddress,
                          ),
                        ),
                      ],
                    ),
                    if (application.description != null &&
                        application.description!.isNotEmpty) ...[
                      const SizedBox(height: 10),
                      Text(application.description!),
                    ],
                    const SizedBox(height: 12),
                    const SizedBox(height: 16),

                    const Text(
                      'Room Details',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 8),

                    ...application.rooms.map((room) {
                      final price = double.tryParse(
                        room['price_per_night'].toString(),
                      ) ??
                          0;

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(0.08),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                room['room_type'] ?? '-',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text('Total Rooms: ${room['total_rooms']}'),
                              Text(
                                'Price per Night: Rp ${price.toStringAsFixed(0)}',
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                    Text(
                      'Submitted: ${application.createdAt?.toLocal().toString().split('.').first ?? '-'}',
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                    if (isPending) ...[
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () =>
                                  _reviewApplication(
                                    application,
                                    'rejected',
                                  ),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.red,
                              ),
                              child: const Text('Reject'),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () =>
                                  _reviewApplication(
                                    application,
                                    'approved',
                                  ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                const Color(0xFF10A05A),
                                foregroundColor: Colors.white,
                              ),
                              child: const Text('Approve'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}