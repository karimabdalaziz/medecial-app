
import 'package:flutter/material.dart';
import 'result_screen.dart';
import '../models/scan_result_model.dart';

class ProcessingScreen extends StatefulWidget {
  final String scanType;
  final String imagePath;
  final String notes;
  final DateTime scanDate;

  const ProcessingScreen({
    Key? key,
    required this.scanType,
    required this.imagePath,
    required this.notes,
    required this.scanDate,
  }) : super(key: key);

  @override
  _ProcessingScreenState createState() => _ProcessingScreenState();
}

class _ProcessingScreenState extends State<ProcessingScreen> {
  @override
  void initState() {
    super.initState();
    
    //  وقت المعالجة 3 ثواني
    Future.delayed(Duration(seconds: 3), () {
      if (mounted) {
        // تيست نتيجه تجريبيه مش حقيقيه
        ScanResultModel demoResult = ScanResultModel.demoResult(
          scanType: widget.scanType,
        );
        
        // يوديني لصفحه ال result
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ResultScreen(result: demoResult),
          ),
        );
      }
    });
  }

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
          'Processing',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: Color(0xFF4A6FFF).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF4A6FFF)),
                    strokeWidth: 4,
                  ),
                ),
              ),
              
              SizedBox(height: 40),
              
           
              Text(
                'Analyzing your ${widget.scanType}...',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              
              SizedBox(height: 15),
              
              // رسالة الانتظار
              Text(
                'This may take 10-15 seconds',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
              
              SizedBox(height: 40),
              
              // Progress bar
              Container(
                width: 250,
                child: LinearProgressIndicator(
                  backgroundColor: Colors.grey[200],
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF4A6FFF)),
                ),
              ),
              
              SizedBox(height: 20),
              
              //الاقتراح
              Text(
                'High resolution scans may take slightly longer',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[500],
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}