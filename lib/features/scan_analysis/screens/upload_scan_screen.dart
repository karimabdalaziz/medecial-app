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
  final TextEditingController _notesController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  File? _selectedImage;

  final List<Map<String, dynamic>> scanTypes = [
    {'name': 'Brain Tumor Scan', 'icon': Icons.psychology},
    {'name': 'Skin Cancer Scan', 'icon': Icons.spa},
    {'name': 'Breast Cancer Scan', 'icon': Icons.female},
    {'name': 'Eye Scan', 'icon': Icons.visibility},
    {'name': 'Lung Cancer Scan', 'icon': Icons.air},
    {'name': 'Heart Scan', 'icon': Icons.favorite},
    {'name': 'Kidney Scan', 'icon': Icons.kitchen},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
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
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
          
              Text(
                'Select Scan Type',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 5),
              Text(
                'Choose the type of scan to start analysis',
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
              SizedBox(height: 20),

              ...scanTypes
                  .map(
                    (scan) => GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedScanType = scan['name'];
                        });
                      },
                      child: Container(
                        margin: EdgeInsets.only(bottom: 15),
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: _selectedScanType == scan['name']
                              ? Color(0xFF4A6FFF).withOpacity(0.1)
                              : Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                            color: _selectedScanType == scan['name']
                                ? Color(0xFF4A6FFF)
                                : Colors.grey[200]!,
                            width: _selectedScanType == scan['name'] ? 2 : 1,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.05),
                              blurRadius: 10,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                           
                            Container(
                              padding: EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Color(0xFF4A6FFF).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(
                                scan['icon'],
                                color: Color(0xFF4A6FFF),
                                size: 28,
                              ),
                            ),
                            SizedBox(width: 15),

                            Expanded(
                              child: Text(
                                scan['name'],
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),


                            Icon(
                              Icons.arrow_forward_ios,
                              size: 16,
                              color: _selectedScanType == scan['name']
                                  ? Color(0xFF4A6FFF)
                                  : Colors.grey[400],
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                  .toList(),

              SizedBox(height: 25),

            
              Text(
                'Upload Files',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 12),
              GestureDetector(
                onTap: () {
                  _selectImage();
                },
                child: Container(
                  padding: EdgeInsets.all(30),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                      color: _selectedImage != null
                          ? Color(0xFF4A6FFF)
                          : Colors.grey[300]!,
                      width: _selectedImage != null ? 2 : 1,
                    ),
                  ),
                  child: _selectedImage == null
                      ? Column(
                          children: [
                            Icon(
                              Icons.cloud_upload_outlined,
                              size: 50,
                              color: Colors.grey[400],
                            ),
                            SizedBox(height: 10),
                            Text(
                              'Tap to upload',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[600],
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              'Supported formats: JPG, PNG, DICOM',
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
                                height: 100,
                                width: 100,
                                fit: BoxFit.cover,
                              ),
                            ),
                            SizedBox(height: 10),
                            Icon(
                              Icons.check_circle,
                              size: 30,
                              color: Colors.green,
                            ),
                            SizedBox(height: 5),
                            Text(
                              'File selected successfully!',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.green,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              'Tap to change file',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[500],
                              ),
                            ),
                          ],
                        ),
                ),
              ),

              SizedBox(height: 25),

             
              Text(
                'Date of Scan',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 12),
              GestureDetector(
                onTap: () {
                  _selectDate(context);
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                        style: TextStyle(fontSize: 16),
                      ),
                      Icon(Icons.calendar_today, color: Color(0xFF4A6FFF)),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 25),

      
              Text(
                'Additional Notes',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 12),
              Container(
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: TextField(
                  controller: _notesController,
                  maxLines: 4,
                  decoration: InputDecoration(
                    hintText: 'Add any relevant details regarding the scan...',
                    border: InputBorder.none,
                    hintStyle: TextStyle(color: Colors.grey[500]),
                  ),
                ),
              ),

              SizedBox(height: 30),

          
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    _submitScan(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF4A6FFF),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 18),
                  ),
                  child: Text(
                    'Submit Scan',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  //  دالة اختيار التاريخ
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

// داله اختيار الصور
  Future<void> _selectImage() async {
    final ImagePicker picker = ImagePicker();

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.photo_library, color: Color(0xFF4A6FFF)),
                title: Text('Choose from Gallery'),
                onTap: () async {
                  Navigator.pop(context);
                  final XFile? pickedFile = await picker.pickImage(
                    source: ImageSource.gallery,
                    maxWidth: 1024,
                    maxHeight: 1024,
                    imageQuality: 85,
                  );

                  if (pickedFile != null) {
                    setState(() {
                      _selectedImage = File(pickedFile.path);
                    });

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('✅ Image selected successfully!'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  }
                },
              ),
              ListTile(
                leading: Icon(Icons.camera_alt, color: Color(0xFF4A6FFF)),
                title: Text('Take a Photo'),
                onTap: () async {
                  Navigator.pop(context);
                  final XFile? pickedFile = await picker.pickImage(
                    source: ImageSource.camera,
                    maxWidth: 1024,
                    maxHeight: 1024,
                    imageQuality: 85,
                  );

                  if (pickedFile != null) {
                    setState(() {
                      _selectedImage = File(pickedFile.path);
                    });

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('✅ Photo taken successfully!'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

 
  void _submitScan(BuildContext context) {
    if (_selectedScanType == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please select scan type'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (_selectedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please upload a scan image'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProcessingScreen(
          scanType: _selectedScanType!,
          imagePath: _selectedImage!.path,
          notes: _notesController.text,
          scanDate: _selectedDate,
        ),
      ),
    );
  }
}
