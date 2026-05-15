import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:project/core/constants/api_constants.dart';
import '../models/scan_result_model.dart';
import 'result_screen.dart';

class ProcessingScreen extends StatefulWidget {
  final String scanType;
  final String imagePath;
  final int? age;
  final String? gender;
  final String? symptoms;

  const ProcessingScreen({
    Key? key,
    required this.scanType,
    required this.imagePath,
    this.age,
    this.gender,
    this.symptoms,
  }) : super(key: key);

  @override
  _ProcessingScreenState createState() => _ProcessingScreenState();
}

class _ProcessingScreenState extends State<ProcessingScreen> {
  @override
  void initState() {
    super.initState();
    _analyseImage();
  }

  String _endpointFor(String scanType) {
    switch (scanType) {
      case 'Brain Tumor Scan':   return ApiConstants.aiBrain;
      case 'Skin Cancer Scan':   return ApiConstants.aiSkin;
      case 'Breast Cancer Scan': return ApiConstants.aiBreast;
      case 'Eye Scan':           return ApiConstants.aiEye;
      case 'Lung Cancer Scan':   return ApiConstants.aiLung;
      case 'Heart Scan':         return ApiConstants.aiHeart;
      case 'Kidney Scan':        return ApiConstants.aiKidney;
      default:                   return ApiConstants.aiSkin;
    }
  }

  Future<void> _analyseImage() async {
    try {
      final request = http.MultipartRequest(
        'POST',
        Uri.parse(_endpointFor(widget.scanType)),
      );

      request.files.add(
        await http.MultipartFile.fromPath('file', widget.imagePath),
      );

      if (widget.age != null) {
        request.fields['age'] = widget.age.toString();
      }
      if (widget.gender != null && widget.gender!.isNotEmpty) {
        request.fields['gender'] = widget.gender!;
      }
      if (widget.symptoms != null && widget.symptoms!.isNotEmpty) {
        request.fields['symptoms'] = widget.symptoms!;
      }

      final streamed = await request.send();
      final response = await http.Response.fromStream(streamed);

      if (!mounted) return;

      if (response.statusCode == 200 || response.statusCode == 201) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        final result = ScanResultModel.fromApiResponse(
          json,
          widget.scanType,
          widget.imagePath,
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => ResultScreen(result: result)),
        );
      } else {
        _showError('Analysis failed (${response.statusCode})');
      }
    } catch (e) {
      if (mounted) _showError('Check your internet connection');
    }
  }

  void _showError(String message) {
    if (!mounted) return;
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('Go Back'),
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
        automaticallyImplyLeading: false,
        title: const Text('Analysing...',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 110,
                height: 110,
                decoration: BoxDecoration(
                  color: const Color(0xFF4A6FFF).withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: CircularProgressIndicator(
                    valueColor:
                        AlwaysStoppedAnimation<Color>(Color(0xFF4A6FFF)),
                    strokeWidth: 4,
                  ),
                ),
              ),
              const SizedBox(height: 36),
              Text(
                'Analysing your ${widget.scanType}...',
                style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                'AI models are processing the image.\nThis may take 15–30 seconds.',
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 36),
              LinearProgressIndicator(
                backgroundColor: Colors.grey[200],
                valueColor: const AlwaysStoppedAnimation<Color>(
                    Color(0xFF4A6FFF)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
