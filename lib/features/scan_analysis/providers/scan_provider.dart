import 'package:flutter/material.dart';
import '../models/scan_model.dart';

class ScanProvider extends ChangeNotifier {
  final List<ScanModel> _scans = [];

  List<ScanModel> get scans => _scans;

  // Function that gets the total number of analyses
  int get totalScansCount => _scans.length;

  // Function that gets the number of completed analyses
  int get completedScansCount =>
      _scans.where((scan) => scan.status == 'completed').length;

  // Function that gets the analyses that are still under processing
  int get processingScansCount =>
      _scans.where((scan) => scan.status == 'processing').length;

  void addScan(ScanModel scan) {
    _scans.add(scan);
    print(' Scan added. Total scans: ${_scans.length}');
    notifyListeners();
  }

  void loadSampleData() {
    // No demo data — scans come from real AI API
    notifyListeners();
  }
}
