import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:project/core/constants/api_constants.dart';
import 'package:project/core/services/auth_storage.dart';
import 'package:project/features/auth/loginscreen.dart';
import '../models/user_model.dart';
import '../widgets/profile_header.dart';
import '../widgets/profile_stats.dart';
import '../widgets/profile_menu_item.dart';
import 'edit_profile_screen.dart';
import 'change_password_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  UserModel? _user;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchProfile();
  }

  Future<void> _fetchProfile() async {
    setState(() => _isLoading = true);
    try {
      final token = await AuthStorage.getToken();
      if (token == null || token.isEmpty) {
        _redirectToLogin();
        return;
      }

      final headers = await AuthStorage.getAuthHeaders();
      final response = await http.get(
        Uri.parse(ApiConstants.myProfile),
        headers: headers,
      );

      if (!mounted) return;

      if (response.statusCode == 401) {
        await AuthStorage.clearSession();
        _redirectToLogin();
        return;
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        _parseAndSetUser(response.body);
      } else {
        Map<String, dynamic>? body;
        try {
          body = jsonDecode(response.body) as Map<String, dynamic>;
        } catch (_) {}
        final msg = body?['message'] as String?;
        _showError(msg ?? 'Loading failed (${response.statusCode})');
      }
    } catch (e) {
      _showError('Make sure you are connected to the internet');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _parseAndSetUser(String body) {
    try {
      final data = jsonDecode(body) as Map<String, dynamic>;

      // Structure: data.patient (patient doc) + data.patient.user (user doc)
      final outer = data['data'] as Map<String, dynamic>? ?? {};
      final p =
          (outer['patient'] ?? outer['data'] ?? outer) as Map<String, dynamic>;
      final userObj = p['user'] as Map<String, dynamic>? ?? {};

      // profilePic can be in user or patient
      final picMap =
          (userObj['profilePic'] ?? p['profilePic']) as Map<String, dynamic>?;
      final picUrl = picMap?['url'] as String?;

      // Parse address
      final addrMap = p['address'] as Map<String, dynamic>?;
      final addressParts = <String>[
        if ((addrMap?['street'] as String? ?? '').isNotEmpty)
          addrMap!['street'] as String,
        if ((addrMap?['city'] as String? ?? '').isNotEmpty)
          addrMap!['city'] as String,
        if ((addrMap?['country'] as String? ?? '').isNotEmpty)
          addrMap!['country'] as String,
      ];

      setState(() {
        _user = UserModel(
          id: p['_id'] as String? ?? '',
          name: userObj['name'] as String? ?? p['name'] as String? ?? '',
          email: userObj['email'] as String? ?? p['email'] as String? ?? '',
          phone: p['phone'] as String? ?? '',
          profileImageUrl:
              (picUrl != null && picUrl.isNotEmpty && picUrl != 'default.jpg')
              ? picUrl
              : null,
          dateOfBirth: p['dateOfBirth'] != null
              ? DateTime.tryParse(p['dateOfBirth'] as String) ?? DateTime(1990)
              : DateTime(1990),
          gender: p['gender'] as String? ?? 'Male',
          bloodType: p['bloodType'] as String? ?? '',
          address: addressParts.join(', '),
          appointmentsCount: 0,
          scansCount: 0,
        );
      });
    } catch (e) {
      debugPrint('❌ PARSE ERROR: $e');
      _showError('Failed to read data');
    }
  }

  void _redirectToLogin() {
    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }

  void _showError(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(msg), backgroundColor: Colors.red));
  }

  void _logout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () async {
              final nav = Navigator.of(context);
              await AuthStorage.clearSession();
              nav.pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const LoginScreen()),
                (route) => false,
              );
            },
            child: const Text('Logout', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'My Profile',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _user == null
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Failed to load profile'),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: _fetchProfile,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            )
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    ProfileHeader(
                      user: _user!,
                      onEditPressed: () async {
                        final updated = await Navigator.push<bool>(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                EditProfileScreen(user: _user!),
                          ),
                        );
                        if (updated == true) await _fetchProfile();
                      },
                    ),
                    const SizedBox(height: 20),
                    ProfileStats(user: _user!),
                    const SizedBox(height: 20),
                    _buildMedicalInfoCard(_user!),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withValues(alpha: 0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: Row(
                              children: [
                                Icon(Icons.settings, color: Colors.grey[700]),
                                const SizedBox(width: 10),
                                const Text(
                                  'Settings',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          ProfileMenuItem(
                            icon: Icons.person_outline,
                            title: 'Edit Profile',
                            subtitle: 'Change your personal information',
                            iconColor: Colors.blue,
                            onTap: () async {
                              final updated = await Navigator.push<bool>(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      EditProfileScreen(user: _user!),
                                ),
                              );
                              if (updated == true) await _fetchProfile();
                            },
                          ),
                          ProfileMenuItem(
                            icon: Icons.lock_outline,
                            title: 'Change Password',
                            subtitle: 'Update your password regularly',
                            iconColor: Colors.purple,
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const ChangePasswordScreen(),
                              ),
                            ),
                          ),
                          ProfileMenuItem(
                            icon: Icons.language,
                            title: 'Language',
                            subtitle: 'English (US)',
                            iconColor: Colors.teal,
                            onTap: () =>
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Language feature coming soon',
                                    ),
                                    backgroundColor: Colors.orange,
                                  ),
                                ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 25),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _logout,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red.withValues(alpha: 0.1),
                          foregroundColor: Colors.red,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 18),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.logout),
                            SizedBox(width: 10),
                            Text(
                              'Logout',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
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

  Widget _buildMedicalInfoCard(UserModel user) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.medical_information, color: Colors.red[400]),
              const SizedBox(width: 8),
              const Text(
                'Medical Info',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildInfoChip(
                  icon: Icons.bloodtype,
                  label: 'Blood Type',
                  value: user.bloodType.isNotEmpty ? user.bloodType : '—',
                  color: Colors.red,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildInfoChip(
                  icon: user.gender == 'Female' ? Icons.female : Icons.male,
                  label: 'Gender',
                  value: user.gender,
                  color: user.gender == 'Female' ? Colors.pink : Colors.blue,
                ),
              ),
            ],
          ),
          if (user.address.isNotEmpty) ...[
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.teal.withValues(alpha: 0.07),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(Icons.location_on, color: Colors.teal[600], size: 20),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Address',
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey[500],
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          user.address,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInfoChip({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(fontSize: 11, color: Colors.grey[500]),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
