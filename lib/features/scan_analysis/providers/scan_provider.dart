
import 'package:flutter/material.dart';
import '../models/scan_model.dart';

class ScanProvider extends ChangeNotifier {
  List<ScanModel> _scans = [];

  List<ScanModel> get scans => _scans;
  
  //  دالة تجيب  عدد التحاليل الكلي
  int get totalScansCount => _scans.length;
  
  //  دالة تجيب عدد التحاليل المكتملة
  int get completedScansCount => _scans.where((scan) => scan.status == 'completed').length;
  
  // دالة تجيب التحاليل الي لسه تحت  المعالجة
  int get processingScansCount => _scans.where((scan) => scan.status == 'processing').length;

  void addScan(ScanModel scan) {
    _scans.add(scan);
    print(' Scan added. Total scans: ${_scans.length}'); 
    notifyListeners();
  }

  void loadSampleData() {
    _scans = [
      ScanModel(
        id: '1',
        type: 'Chest X-Ray',
        date: DateTime.now(),
        imagePath: '',
        status: 'completed',
        riskLevel: 'low',
        confidenceScore: 98,
        findings: ['Regular Edges', 'Uniform Pigmentation', 'No Inflammation'],
        recommendation: 'Routine check-up in 6 months',
      ),
      ScanModel(
        id: '2',
        type: 'MRI - Knee Left',
        date: DateTime(2023, 7, 2),
        imagePath: '',
        status: 'completed',
        riskLevel: 'low',
      ),
      ScanModel(
        id: '3',
        type: 'Brain CT Scan',
        date: DateTime(2023, 6, 28),
        imagePath: '',
        status: 'completed',
        riskLevel: 'medium',
      ),
    ];
    notifyListeners();
  }
}