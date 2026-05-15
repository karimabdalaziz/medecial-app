import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'processing_screen.dart';

class UploadScanScreen extends StatefulWidget {
  @override
  _UploadScanScreenState createState() => _UploadScanScreenState();
}

class _UploadScanScreenState extends State<UploadScanScreen> {
  String? _selectedScanType;
  File? _selectedImage;
  final _symptomsController = TextEditingController();
  final _ageController = TextEditingController();
  String _selectedGender = 'male';

  final List<Map<String, dynamic>> scanTypes = [
    {'name': 'Brain Tumor Scan', 'icon': Icons.psychology, 'endpoint': 'brain'},
    {'name': 'Skin Cancer Scan', 'icon': Icons.spa, 'endpoint': 'skin'},
    {'name': 'Breast Cancer Scan', 'icon': Icons.female, 'endpoint': 'breast'},
    {'name': 'Eye Scan', 'icon': Icons.visibility, 'endpoint': 'eye'},
    {'name': 'Lung Cancer Scan', 'icon': Icons.air, 'endpoint': 'lung'},
    {'name': 'Heart Scan', 'icon': Icons.favorite, 'endpoint': 'heart'},
    {'name': 'Kidney Scan', 'icon': Icons.water_drop, 'endpoint': 'kidney'},
  ];

  @override
  void dispose() {
    _symptomsController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  Future<void> _selectImage() async {
    final picker = ImagePicker();
    showModalBottomSheet(
      context: context,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(
                Icons.photo_library,
                color: Color(0xFF4A6FFF),
              ),
              title: const Text('Choose from Gallery'),
              onTap: () async {
                Navigator.pop(ctx);
                final file = await picker.pickImage(
                  source: ImageSource.gallery,
                  imageQuality: 85,
                );
                if (file != null)
                  setState(() => _selectedImage = File(file.path));
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt, color: Color(0xFF4A6FFF)),
              title: const Text('Take a Photo'),
              onTap: () async {
                Navigator.pop(ctx);
                final file = await picker.pickImage(
                  source: ImageSource.camera,
                  imageQuality: 85,
                );
                if (file != null)
                  setState(() => _selectedImage = File(file.path));
              },
            ),
          ],
        ),
      ),
    );
  }

  void _submit() {
    if (_selectedScanType == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a scan type'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    if (_selectedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please upload a scan image'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final age = int.tryParse(_ageController.text.trim());

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProcessingScreen(
          scanType: _selectedScanType!,
          imagePath: _selectedImage!.path,
          age: age,
          gender: _selectedGender,
          symptoms: _symptomsController.text.trim(),
        ),
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
          'Upload Scan',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Scan Type ──
              const Text(
                'Select Scan Type',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 5),
              Text(
                'Choose the type of scan to start analysis',
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
              const SizedBox(height: 16),
              ...scanTypes.map(
                (scan) => GestureDetector(
                  onTap: () => setState(() => _selectedScanType = scan['name']),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: _selectedScanType == scan['name']
                          ? const Color(0xFF4A6FFF).withValues(alpha: 0.08)
                          : Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: _selectedScanType == scan['name']
                            ? const Color(0xFF4A6FFF)
                            : Colors.grey[200]!,
                        width: _selectedScanType == scan['name'] ? 2 : 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: const Color(
                              0xFF4A6FFF,
                            ).withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            scan['icon'] as IconData,
                            color: const Color(0xFF4A6FFF),
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Text(
                            scan['name'] as String,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 14,
                          color: _selectedScanType == scan['name']
                              ? const Color(0xFF4A6FFF)
                              : Colors.grey[400],
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // ── Image Upload ──
              const Text(
                'Upload Image',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              GestureDetector(
                onTap: _selectImage,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: _selectedImage != null
                          ? const Color(0xFF4A6FFF)
                          : Colors.grey[300]!,
                      width: _selectedImage != null ? 2 : 1,
                    ),
                  ),
                  child: _selectedImage == null
                      ? Column(
                          children: [
                            Icon(
                              Icons.cloud_upload_outlined,
                              size: 48,
                              color: Colors.grey[400],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Tap to upload',
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.grey[600],
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'JPG, PNG supported',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[500],
                              ),
                            ),
                          ],
                        )
                      : Column(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.file(
                                _selectedImage!,
                                height: 120,
                                width: 120,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Icon(
                              Icons.check_circle,
                              color: Colors.green,
                              size: 28,
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              'Image selected — tap to change',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.green,
                              ),
                            ),
                          ],
                        ),
                ),
              ),

              const SizedBox(height: 24),

              // ── Optional Patient Info ──
              Row(
                children: [
                  const Text(
                    'Patient Info',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '(optional)',
                    style: TextStyle(fontSize: 13, color: Colors.grey[500]),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                'Adding age, gender, and symptoms generates a personalised Arabic report',
                style: TextStyle(fontSize: 12, color: Colors.grey[500]),
              ),
              const SizedBox(height: 14),

              // Age
              _buildInputContainer(
                child: TextField(
                  controller: _ageController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Age',
                    border: InputBorder.none,
                    prefixIcon: Icon(Icons.cake_outlined, color: Colors.grey),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Gender
              _buildInputContainer(
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedGender,
                    isExpanded: true,
                    icon: const Icon(
                      Icons.arrow_drop_down,
                      color: Color(0xFF4A6FFF),
                    ),
                    items: const [
                      DropdownMenuItem(value: 'male', child: Text('Male')),
                      DropdownMenuItem(value: 'female', child: Text('Female')),
                    ],
                    onChanged: (v) => setState(() => _selectedGender = v!),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Symptoms
              _buildInputContainer(
                child: TextField(
                  controller: _symptomsController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    labelText: 'Symptoms (Arabic or English)',
                    border: InputBorder.none,
                    hintText: 'e.g. change in skin color and itching',
                    hintStyle: TextStyle(color: Colors.grey[400]),
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // ── Submit ──
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4A6FFF),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text(
                    'Analyse Scan',
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
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

  Widget _buildInputContainer({required Widget child}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: child,
    );
  }
}
