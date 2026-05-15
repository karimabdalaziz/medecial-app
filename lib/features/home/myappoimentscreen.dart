import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:project/core/constants/api_constants.dart';
import 'package:project/core/services/auth_storage.dart';

class Myappoimentscreen extends StatefulWidget {
  const Myappoimentscreen({Key? key}) : super(key: key);

  @override
  _AppointmentsScreenState createState() => _AppointmentsScreenState();
}

class _AppointmentsScreenState extends State<Myappoimentscreen> {
  List<Map<String, dynamic>> _appointments = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchAppointments();
  }

  Future<void> _fetchAppointments() async {
    setState(() => _isLoading = true);
    try {
      final headers = await AuthStorage.getAuthHeaders();
      final response = await http.get(
        Uri.parse(ApiConstants.myAppointments),
        headers: headers,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final raw = data['data'] as Map<String, dynamic>? ?? {};
        final list = (raw['appointments'] ?? raw['data'] ?? []) as List;

        if (!mounted) return;
        setState(() {
          _appointments = list.map((item) {
            final apt = item as Map<String, dynamic>;
            final doctorRaw = apt['doctor'];
            final doctor = doctorRaw is Map<String, dynamic> ? doctorRaw : <String, dynamic>{};
            final startTime = apt['startTime'] as String?;
            final dt = startTime != null ? DateTime.tryParse(startTime)?.toLocal() : null;

            return {
              'id': apt['id'] as String? ?? apt['_id'] as String? ?? '',
              'doctorName': doctor['displayName'] as String? ?? doctor['name'] as String? ?? 'Unknown Doctor',
              'specialty': doctor['specialty'] as String? ?? '',
              'date': dt != null ? '${dt.day}/${dt.month}/${dt.year}' : 'N/A',
              'time': dt != null ? _formatTime(dt) : 'N/A',
              'status': apt['status'] as String? ?? 'pending',
            };
          }).toList();
        });
      } else {
        _showError('Failed to load appointments');
      }
    } catch (_) {
      _showError('Check your internet connection');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  String _formatTime(DateTime dt) {
    final hour = dt.hour;
    final minute = dt.minute.toString().padLeft(2, '0');
    final period = hour >= 12 ? 'PM' : 'AM';
    final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
    return '$displayHour:$minute $period';
  }

  void _showError(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: Colors.red),
    );
  }

  Future<void> _cancelAppointment(String id) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancel Appointment'),
        content: const Text('Are you sure you want to cancel this appointment?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('No', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Yes, Cancel'),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    final messenger = ScaffoldMessenger.of(context);

    try {
      final headers = await AuthStorage.getAuthHeaders();
      final response = await http.patch(
        Uri.parse(ApiConstants.cancelAppointment(id)),
        headers: headers,
      );

      if (!mounted) return;

      if (response.statusCode == 200 || response.statusCode == 201) {
        messenger.showSnackBar(
          const SnackBar(content: Text('Appointment cancelled'), backgroundColor: Colors.green),
        );
        _fetchAppointments();
      } else {
        final body = jsonDecode(response.body) as Map<String, dynamic>;
        messenger.showSnackBar(
          SnackBar(
            content: Text(body['message'] as String? ?? 'Failed to cancel'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (_) {
      if (!mounted) return;
      messenger.showSnackBar(
        const SnackBar(content: Text('Check your internet connection'), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final upcoming = _appointments.where((a) => a['status'] != 'cancelled').toList();
    final cancelled = _appointments.where((a) => a['status'] == 'cancelled').toList();

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text(
            'My Appointments',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20),
          ),
          centerTitle: true,
          bottom: TabBar(
            indicatorColor: const Color(0xFF4A6FFF),
            labelColor: const Color(0xFF4A6FFF),
            unselectedLabelColor: Colors.grey,
            tabs: [
              Tab(text: 'Upcoming (${upcoming.length})'),
              Tab(text: 'Cancelled (${cancelled.length})'),
            ],
          ),
        ),
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : RefreshIndicator(
                onRefresh: _fetchAppointments,
                child: TabBarView(
                  children: [
                    _buildList(upcoming, canCancel: true),
                    _buildList(cancelled, canCancel: false),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildList(List<Map<String, dynamic>> appointments, {required bool canCancel}) {
    if (appointments.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.calendar_today, size: 80, color: Colors.grey[300]),
            const SizedBox(height: 20),
            Text('No appointments', style: TextStyle(color: Colors.grey[500], fontSize: 16)),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: appointments.length,
      itemBuilder: (context, index) {
        final apt = appointments[index];
        final status = apt['status'] as String;
        final isActive = status == 'confirmed' || status == 'pending';

        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: const Color(0xFF4A6FFF).withValues(alpha: 0.1),
                      child: const Icon(Icons.person, color: Color(0xFF4A6FFF)),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            apt['doctorName'] as String,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          if ((apt['specialty'] as String).isNotEmpty)
                            Text(
                              apt['specialty'] as String,
                              style: TextStyle(color: Colors.grey[600], fontSize: 13),
                            ),
                          Text(
                            '${apt['date']} • ${apt['time']}',
                            style: TextStyle(color: Colors.grey[600], fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: isActive
                            ? Colors.green.withValues(alpha: 0.1)
                            : Colors.red.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        status.toUpperCase(),
                        style: TextStyle(
                          color: isActive ? Colors.green : Colors.red,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                if (canCancel) ...[
                  const SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerRight,
                    child: OutlinedButton.icon(
                      onPressed: () => _cancelAppointment(apt['id'] as String),
                      icon: const Icon(Icons.cancel_outlined, size: 16),
                      label: const Text('Cancel'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.red,
                        side: const BorderSide(color: Colors.red),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}
