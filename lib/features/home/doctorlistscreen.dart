import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:project/core/constants/api_constants.dart';
import 'package:project/core/services/auth_storage.dart';
import 'package:project/features/home/bookappointmrntscreen.dart';

class FindDoctorScreen extends StatefulWidget {
  @override
  _FindDoctorScreenState createState() => _FindDoctorScreenState();
}

class _FindDoctorScreenState extends State<FindDoctorScreen> {
  List<Map<String, dynamic>> _doctors = [];
  bool _isLoading = true;
  int _selectedCategory = 0;

  final List<String> categories = [
    'All',
    'Dermatology',
    'Cardiology',
    'Pediatrics',
    'Psychiatry',
    'Orthopedics',
    'Dentistry',
    'General',
  ];

  @override
  void initState() {
    super.initState();
    _fetchDoctors();
  }

  Future<void> _fetchDoctors() async {
    setState(() => _isLoading = true);
    try {
      final headers = await AuthStorage.getAuthHeaders();
      final response = await http.get(Uri.parse(ApiConstants.doctors), headers: headers);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final raw = data['data'] as Map<String, dynamic>? ?? {};
        final list = (raw['data'] ?? raw['doctors'] ?? []) as List;

        if (!mounted) return;
        setState(() {
          _doctors = list.map((item) {
            final d = item as Map<String, dynamic>;
            final wh = d['workingHours'] as Map<String, dynamic>? ?? {};
            final schedule = (d['schedule'] as List?)?.map((e) => e.toString()).toList() ?? [];
            return {
              'id': d['_id'] as String? ?? '',
              'name': d['displayName'] as String? ?? 'Unknown',
              'specialty': d['specialty'] as String? ?? '',
              'description': d['description'] as String? ?? '',
              'price': (d['price'] as num?)?.toInt() ?? 0,
              'yearsOfExperience': (d['yearsOfExperience'] as num?)?.toInt() ?? 0,
              'gender': d['gender'] as String? ?? '',
              'schedule': schedule,
              'workingStart': wh['start'] as String? ?? '',
              'workingEnd': wh['end'] as String? ?? '',
              'image': d['image'] as String? ?? '',
            };
          }).toList();
        });
      } else {
        _showError('Failed to load doctors');
      }
    } catch (_) {
      _showError('Check your internet connection');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showError(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: Colors.red),
    );
  }

  List<Map<String, dynamic>> get _filtered {
    if (_selectedCategory == 0) return _doctors;
    final cat = categories[_selectedCategory].toLowerCase();
    return _doctors.where((d) => (d['specialty'] as String).toLowerCase() == cat).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Find a Doctor',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _fetchDoctors,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Categories filter
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: categories.asMap().entries.map((entry) {
                            final index = entry.key;
                            final category = entry.value;
                            final selected = _selectedCategory == index;
                            return Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: GestureDetector(
                                onTap: () => setState(() => _selectedCategory = index),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                  decoration: BoxDecoration(
                                    color: selected ? const Color(0xFF4A6FFF) : Colors.white,
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: selected ? const Color(0xFF4A6FFF) : Colors.grey[300]!,
                                    ),
                                  ),
                                  child: Text(
                                    category,
                                    style: TextStyle(
                                      color: selected ? Colors.white : Colors.grey[700],
                                      fontWeight: FontWeight.w500,
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        '${_filtered.length} Doctor${_filtered.length != 1 ? 's' : ''} Found',
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      ),
                      const SizedBox(height: 12),
                      Column(
                        children: _filtered.map((doctor) => _buildDoctorCard(doctor)).toList(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  Widget _buildDoctorCard(Map<String, dynamic> doctor) {
    final schedule = doctor['schedule'] as List<String>;
    final specialty = doctor['specialty'] as String;

    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => DoctorProfileScreen(doctor: doctor)),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(color: Colors.grey.withValues(alpha: 0.08), blurRadius: 10, offset: const Offset(0, 4)),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: const Color(0xFF4A6FFF).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(
                    (doctor['gender'] as String) == 'female' ? Icons.person : Icons.person,
                    color: const Color(0xFF4A6FFF),
                    size: 34,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        doctor['name'] as String,
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        _capitalize(specialty),
                        style: const TextStyle(color: Color(0xFF4A6FFF), fontWeight: FontWeight.w500, fontSize: 13),
                      ),
                      const SizedBox(height: 3),
                      Row(
                        children: [
                          Icon(Icons.work_outline, size: 13, color: Colors.grey[500]),
                          const SizedBox(width: 4),
                          Text(
                            '${doctor['yearsOfExperience']} yrs exp',
                            style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                          ),
                          const SizedBox(width: 12),
                          Icon(Icons.attach_money, size: 13, color: Colors.grey[500]),
                          Text(
                            '${doctor['price']} EGP',
                            style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (schedule.isNotEmpty) ...[
              const SizedBox(height: 12),
              Wrap(
                spacing: 6,
                children: schedule.map((day) => Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.green.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    _capitalize(day),
                    style: const TextStyle(fontSize: 11, color: Colors.green, fontWeight: FontWeight.w500),
                  ),
                )).toList(),
              ),
            ],
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BookAppointmentScreen(
                      doctorId: doctor['id'] as String,
                      doctorName: doctor['name'] as String,
                      specialty: _capitalize(doctor['specialty'] as String),
                    ),
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4A6FFF),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: const Text('Book Appointment', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _capitalize(String s) =>
      s.isEmpty ? s : s[0].toUpperCase() + s.substring(1);
}

// ─────────────────────────────────────────────
class DoctorProfileScreen extends StatelessWidget {
  final Map<String, dynamic> doctor;

  const DoctorProfileScreen({super.key, required this.doctor});

  String _capitalize(String s) =>
      s.isEmpty ? s : s[0].toUpperCase() + s.substring(1);

  @override
  Widget build(BuildContext context) {
    final schedule = doctor['schedule'] as List<String>;
    final specialty = _capitalize(doctor['specialty'] as String);
    final workingStart = doctor['workingStart'] as String;
    final workingEnd = doctor['workingEnd'] as String;
    final price = doctor['price'] as int;
    final years = doctor['yearsOfExperience'] as int;
    final description = doctor['description'] as String;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Doctor Profile', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header card
            Container(
              width: double.infinity,
              color: Colors.white,
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Container(
                    width: 90,
                    height: 90,
                    decoration: BoxDecoration(
                      color: const Color(0xFF4A6FFF).withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.person, color: Color(0xFF4A6FFF), size: 50),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    doctor['name'] as String,
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(specialty, style: const TextStyle(color: Color(0xFF4A6FFF), fontSize: 16, fontWeight: FontWeight.w500)),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildStat(Icons.work_outline, '$years yrs', 'Experience', Colors.blue),
                      _buildStat(Icons.attach_money, '$price EGP', 'Per Visit', Colors.green),
                      _buildStat(Icons.access_time, '$workingStart - $workingEnd', 'Hours', Colors.orange),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // About
            if (description.isNotEmpty)
              _buildSection(
                title: 'About',
                child: Text(description, style: TextStyle(fontSize: 14, color: Colors.grey[700], height: 1.5)),
              ),

            const SizedBox(height: 12),

            // Schedule
            _buildSection(
              title: 'Available Days',
              child: schedule.isEmpty
                  ? Text('Not specified', style: TextStyle(color: Colors.grey[500]))
                  : Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: schedule.map((day) => Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          color: const Color(0xFF4A6FFF).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: const Color(0xFF4A6FFF).withValues(alpha: 0.3)),
                        ),
                        child: Text(
                          _capitalize(day),
                          style: const TextStyle(color: Color(0xFF4A6FFF), fontWeight: FontWeight.w600),
                        ),
                      )).toList(),
                    ),
            ),

            const SizedBox(height: 24),

            // Book button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Consultation Fee', style: TextStyle(fontSize: 13, color: Colors.grey[500])),
                        Text('$price EGP', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BookAppointmentScreen(
                            doctorId: doctor['id'] as String,
                            doctorName: doctor['name'] as String,
                            specialty: specialty,
                          ),
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4A6FFF),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text('Book Now', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildStat(IconData icon, String value, String label, Color color) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(color: color.withValues(alpha: 0.1), shape: BoxShape.circle),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(height: 6),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
        Text(label, style: TextStyle(fontSize: 11, color: Colors.grey[500])),
      ],
    );
  }

  Widget _buildSection({required String title, required Widget child}) {
    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}
