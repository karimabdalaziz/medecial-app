import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:project/core/constants/api_constants.dart';
import 'package:project/core/services/auth_storage.dart';
import 'package:project/features/home/homedashboardscreen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _displayNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _streetController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();
  final TextEditingController _medicalHistoryController =
      TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordConfirmController =
      TextEditingController();

  bool _isPasswordVisible = false;
  bool _isPasswordConfirmVisible = false;
  bool _agreeToTerms = false;
  bool _isLoading = false;

  String? _selectedBloodType;
  final List<String> _bloodTypes = [
    'A+',
    'A-',
    'B+',
    'B-',
    'O+',
    'O-',
    'AB+',
    'AB-',
  ];

  DateTime? _selectedDateOfBirth;

  @override
  void dispose() {
    _nameController.dispose();
    _displayNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _streetController.dispose();
    _cityController.dispose();
    _countryController.dispose();
    _medicalHistoryController.dispose();
    _passwordController.dispose();
    _passwordConfirmController.dispose();
    super.dispose();
  }

  Future<void> _pickDateOfBirth() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) setState(() => _selectedDateOfBirth = picked);
  }

  bool _validateFields() {
    if (_nameController.text.trim().isEmpty) {
      _showError('Please enter the full name');
      return false;
    }
    if (_displayNameController.text.trim().isEmpty) {
      _showError('Please enter the display name');
      return false;
    }
    if (_emailController.text.trim().isEmpty) {
      _showError('Please enter the email');
      return false;
    }
    if (_phoneController.text.trim().isEmpty) {
      _showError('Please enter the phone number');
      return false;
    }
    if (_streetController.text.trim().isEmpty) {
      _showError('Please enter the street');
      return false;
    }
    if (_cityController.text.trim().isEmpty) {
      _showError('Please enter the city');
      return false;
    }
    if (_countryController.text.trim().isEmpty) {
      _showError('Please enter the country');
      return false;
    }
    if (_selectedBloodType == null) {
      _showError('Please choose blood type');
      return false;
    }
    if (_selectedDateOfBirth == null) {
      _showError('Please choose date of birth');
      return false;
    }
    if (_passwordController.text.length < 8) {
      _showError('Password must be at least 8 characters');
      return false;
    }
    if (_passwordController.text != _passwordConfirmController.text) {
      _showError('Password does not match');
      return false;
    }
    if (!_agreeToTerms) {
      _showError('You must agree to the terms and conditions');
      return false;
    }
    return true;
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  void _showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.green),
    );
  }

  Future<void> _autoLogin(String email, String password) async {
    try {
      final res = await http.post(
        Uri.parse(ApiConstants.login),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );
      if (res.statusCode == 200 || res.statusCode == 201) {
        final data = jsonDecode(res.body) as Map<String, dynamic>;
        final token = (data['token'] as String? ?? '').trim();
        final outer = data['data'];
        Map<String, dynamic> user;
        if (outer is Map<String, dynamic>) {
          final inner = outer['user'] ?? outer['patient'] ?? outer;
          user = inner is Map<String, dynamic> ? inner : outer;
        } else {
          user = {};
        }
        await AuthStorage.saveSession(
          token: token,
          userId: user['_id'] as String? ?? '',
          name: user['name'] as String? ?? '',
          email: user['email'] as String? ?? email,
          role: user['role'] as String? ?? 'patient',
        );
      }
    } catch (_) {}
    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const HomeDashboardScreen()),
      (route) => false,
    );
  }

  Future<void> _signUp() async {
    if (!_validateFields()) return;

    setState(() => _isLoading = true);

    try {
      final response = await http.post(
        Uri.parse(ApiConstants.signupPatient),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': _nameController.text.trim(),
          'email': _emailController.text.trim(),
          'password': _passwordController.text,
          'passwordConfirm': _passwordConfirmController.text,
          'displayName': _displayNameController.text.trim(),
          'phone': _phoneController.text.trim(),
          'address': {
            'street': _streetController.text.trim(),
            'city': _cityController.text.trim(),
            'country': _countryController.text.trim(),
          },
          'bloodType': _selectedBloodType,
          'dateOfBirth':
              '${_selectedDateOfBirth!.year}-${_selectedDateOfBirth!.month.toString().padLeft(2, '0')}-${_selectedDateOfBirth!.day.toString().padLeft(2, '0')}',
          if (_medicalHistoryController.text.trim().isNotEmpty)
            'medicalHistory': _medicalHistoryController.text.trim(),
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        _showSuccess('Account created successfully!');
        await _autoLogin(
          _emailController.text.trim(),
          _passwordController.text,
        );
      } else {
        Map<String, dynamic>? body;
        try {
          body = jsonDecode(response.body) as Map<String, dynamic>;
        } catch (_) {}
        final msg =
            body?['message'] as String? ??
            body?['error'] as String? ??
            response.body.substring(0, response.body.length.clamp(0, 150));
        _showError('(${response.statusCode}) $msg');
      }
    } catch (e) {
      _showError('Make sure you are connected to the internet and try again');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Widget _buildField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    String? hint,
    TextInputType keyboardType = TextInputType.text,
    bool obscure = false,
    Widget? suffixIcon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            color: Color(0xFF2C3E50),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(10),
          ),
          child: TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            obscureText: obscure,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 16,
              ),
              border: InputBorder.none,
              hintText: hint,
              prefixIcon: Icon(icon, color: Colors.grey),
              suffixIcon: suffixIcon,
            ),
          ),
        ),
        const SizedBox(height: 20),
      ],
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
          'Create Account',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Please enter your details to register.',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                const SizedBox(height: 30),

                _buildField(
                  label: 'Full Name',
                  controller: _nameController,
                  icon: Icons.person_outline,
                  hint: 'Ali Ahmed',
                ),
                _buildField(
                  label: 'Display Name',
                  controller: _displayNameController,
                  icon: Icons.badge_outlined,
                  hint: 'Ali',
                ),
                _buildField(
                  label: 'Email Address',
                  controller: _emailController,
                  icon: Icons.email_outlined,
                  hint: 'name@example.com',
                  keyboardType: TextInputType.emailAddress,
                ),
                _buildField(
                  label: 'Phone Number',
                  controller: _phoneController,
                  icon: Icons.phone_outlined,
                  hint: '01012345678',
                  keyboardType: TextInputType.phone,
                ),
                _buildField(
                  label: 'Street',
                  controller: _streetController,
                  icon: Icons.signpost_outlined,
                  hint: 'Al Rehab',
                ),
                _buildField(
                  label: 'City',
                  controller: _cityController,
                  icon: Icons.location_city_outlined,
                  hint: 'Cairo',
                ),
                _buildField(
                  label: 'Country',
                  controller: _countryController,
                  icon: Icons.flag_outlined,
                  hint: 'Egypt',
                ),

                const Text(
                  'Blood Type',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF2C3E50),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey[300]!),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _selectedBloodType,
                      isExpanded: true,
                      hint: const Text(
                        'Select blood type',
                        style: TextStyle(color: Colors.grey),
                      ),
                      items: _bloodTypes
                          .map(
                            (type) => DropdownMenuItem(
                              value: type,
                              child: Text(type),
                            ),
                          )
                          .toList(),
                      onChanged: (value) =>
                          setState(() => _selectedBloodType = value),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                const Text(
                  'Date of Birth',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF2C3E50),
                  ),
                ),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: _pickDateOfBirth,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 16,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[300]!),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.cake_outlined, color: Colors.grey),
                        const SizedBox(width: 12),
                        Text(
                          _selectedDateOfBirth == null
                              ? 'Select date of birth'
                              : '${_selectedDateOfBirth!.day}/${_selectedDateOfBirth!.month}/${_selectedDateOfBirth!.year}',
                          style: TextStyle(
                            color: _selectedDateOfBirth == null
                                ? Colors.grey
                                : Colors.black87,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                const Text(
                  'Password',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF2C3E50),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey[300]!),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextFormField(
                    controller: _passwordController,
                    obscureText: !_isPasswordVisible,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 16,
                      ),
                      border: InputBorder.none,
                      hintText: '••••••',
                      hintStyle: const TextStyle(
                        letterSpacing: 3.0,
                        fontSize: 20,
                        color: Colors.grey,
                      ),
                      prefixIcon: const Icon(
                        Icons.lock_outline,
                        color: Colors.grey,
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Colors.grey,
                        ),
                        onPressed: () => setState(
                          () => _isPasswordVisible = !_isPasswordVisible,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                const Text(
                  'Confirm Password',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF2C3E50),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey[300]!),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextFormField(
                    controller: _passwordConfirmController,
                    obscureText: !_isPasswordConfirmVisible,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 16,
                      ),
                      border: InputBorder.none,
                      hintText: '••••••',
                      hintStyle: const TextStyle(
                        letterSpacing: 3.0,
                        fontSize: 20,
                        color: Colors.grey,
                      ),
                      prefixIcon: const Icon(
                        Icons.lock_outline,
                        color: Colors.grey,
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isPasswordConfirmVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Colors.grey,
                        ),
                        onPressed: () => setState(
                          () => _isPasswordConfirmVisible =
                              !_isPasswordConfirmVisible,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                _buildField(
                  label: 'Medical History',
                  controller: _medicalHistoryController,
                  icon: Icons.medical_information_outlined,
                  hint: 'No known medical conditions',
                ),

                Row(
                  children: [
                    Checkbox(
                      value: _agreeToTerms,
                      onChanged: (value) =>
                          setState(() => _agreeToTerms = value!),
                      activeColor: const Color(0xFF4285F4),
                    ),
                    Expanded(
                      child: RichText(
                        text: const TextSpan(
                          style: TextStyle(color: Colors.grey, fontSize: 14),
                          children: [
                            TextSpan(text: 'Agree to the '),
                            TextSpan(
                              text: 'Medical Privacy Policy',
                              style: TextStyle(
                                color: Color(0xFF4285F4),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(text: ' and '),
                            TextSpan(
                              text: 'Terms of Service',
                              style: TextStyle(
                                color: Color(0xFF4285F4),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),

                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: (_agreeToTerms && !_isLoading) ? _signUp : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4285F4),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text(
                            'Create Account',
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                  ),
                ),
                const SizedBox(height: 25),

                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Already have an account? ',
                        style: TextStyle(color: Colors.grey),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text(
                          'Log In',
                          style: TextStyle(
                            color: Color(0xFF4285F4),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
