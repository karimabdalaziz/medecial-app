import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/scan_provider.dart';
import '../models/scan_model.dart';
import 'upload_scan_screen.dart'; 

class ScanHomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    
    return ChangeNotifierProvider(
      create: (_) => ScanProvider()..loadSampleData(),
      child: Consumer<ScanProvider>(
        builder: (context, scanProvider, child) {
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
                'Scan Analysis',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              centerTitle: true,
              actions: [
                IconButton(
                  icon: Icon(Icons.history, color: Colors.grey[700]),
                  onPressed: () {
                    // هنضيف بعدين صفحة السجل
                  },
                ),
              ],
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Welcome Section
                    Text(
                      'WELCOME BACK',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                        letterSpacing: 1,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Alex Johnson',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 25),

                    // New Analysis Card
                    Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFF6673F7), Color(0xFF4A6FFF)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Color(0xFF4A6FFF).withOpacity(0.3),
                            blurRadius: 15,
                            offset: Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.upload_file,
                                color: Colors.white,
                                size: 28,
                              ),
                              SizedBox(width: 10),
                              Text(
                                'New Analysis',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 12),
                          Text(
                            'Upload your recent X-Ray, MRI, or CT scan for instant AI-driven feedback and analysis.',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.9),
                              fontSize: 14,
                              height: 1.5,
                            ),
                          ),
                          SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () {
                              
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => UploadScanScreen(),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: Color(0xFF4A6FFF),
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              padding: EdgeInsets.symmetric(
                                horizontal: 30,
                                vertical: 14,
                              ),
                            ),
                            child: Text(
                              'Upload Scan',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 30),

                  
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Recent History',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                      
                          },
                          child: Text(
                            'See All',
                            style: TextStyle(
                              color: Color(0xFF4A6FFF),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 15),

                    scanProvider.scans.isEmpty
                        ? _buildEmptyState()
                        : Column(
                            children: scanProvider.scans
                                .map((scan) => _buildScanCard(scan))
                                .toList(),
                          ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  //  بطاقة عرض التحليل
  Widget _buildScanCard(ScanModel scan) {
    Color riskColor;
    switch (scan.riskLevel) {
      case 'low':
        riskColor = Colors.green;
        break;
      case 'medium':
        riskColor = Colors.orange;
        break;
      case 'high':
        riskColor = Colors.red;
        break;
      default:
        riskColor = Colors.grey;
    }

    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 4),
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
              _getScanIcon(scan.type),
              color: Color(0xFF4A6FFF),
              size: 24,
            ),
          ),
          SizedBox(width: 15),

       
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  scan.type,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  scan.status == 'completed'
                      ? 'Analyzed • ${_formatDate(scan.date)}'
                      : 'Processing...',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),

          // Risk Badge
          if (scan.status == 'completed' && scan.riskLevel != null)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: riskColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                scan.riskLevel!.toUpperCase(),
                style: TextStyle(
                  color: riskColor,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

          if (scan.status == 'processing')
            SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF4A6FFF)),
              ),
            ),
        ],
      ),
    );
  }

  //  حالة عدم وجود تحاليل
  Widget _buildEmptyState() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 40),
      child: Column(
        children: [
          Icon(
            Icons.analytics_outlined,
            size: 70,
            color: Colors.grey[300],
          ),
          SizedBox(height: 15),
          Text(
            'No scans yet',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Upload your first scan to get AI analysis',
            style: TextStyle(
              color: Colors.grey[500],
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

 
  IconData _getScanIcon(String type) {
    if (type.contains('X-Ray')) return Icons.radar;
    if (type.contains('MRI')) return Icons.thirty_fps;
    if (type.contains('CT')) return Icons.threesixty;
    return Icons.image;
  }

  
  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}