import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import '../models/scan_result_model.dart';

class ResultScreen extends StatelessWidget {
  final ScanResultModel result;

  const ResultScreen({Key? key, required this.result}) : super(key: key);

  Color get _severityColor {
    switch (result.severity) {
      case 'high':   return Colors.red;
      case 'medium': return Colors.orange;
      case 'low':    return Colors.green;
      default:       return Colors.blue;
    }
  }

  String get _severityLabel {
    switch (result.severity) {
      case 'high':   return 'HIGH RISK';
      case 'medium': return 'MODERATE';
      case 'low':    return 'LOW RISK';
      default:       return result.severity.toUpperCase();
    }
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
        title: const Text('Analysis Result',
            style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 20)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // ── Header: scan type chip + prediction + confidence ──
            Container(
              color: Colors.white,
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFF4A6FFF).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(result.scanType,
                        style: const TextStyle(
                            color: Color(0xFF4A6FFF),
                            fontSize: 13,
                            fontWeight: FontWeight.w600)),
                  ),
                  const SizedBox(height: 20),

                  // Risk badge
                  Container(
                    width: 110,
                    height: 110,
                    decoration: BoxDecoration(
                      color: _severityColor.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                      border: Border.all(
                          color: _severityColor.withValues(alpha: 0.4),
                          width: 3),
                    ),
                    child: Center(
                      child: Text(
                        _severityLabel,
                        style: TextStyle(
                            color: _severityColor,
                            fontSize: 13,
                            fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Predicted name
                  Text(
                    result.predictedName,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),

                  // Confidence bar
                  if (result.confidence > 0) ...[
                    Text(
                      '${result.confidence.toStringAsFixed(1)}% Confidence',
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: _severityColor),
                    ),
                    const SizedBox(height: 10),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: LinearProgressIndicator(
                        value: result.confidence / 100,
                        minHeight: 8,
                        backgroundColor: Colors.grey[200],
                        valueColor:
                            AlwaysStoppedAnimation<Color>(_severityColor),
                      ),
                    ),
                  ],

                  // Heart area percent
                  if (result.heartAreaPercent != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      'Heart Area: ${result.heartAreaPercent!.toStringAsFixed(1)}%',
                      style:
                          TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                  ],

                  const SizedBox(height: 6),
                  Text(
                    'Analysed: ${result.analysisDate.day}/${result.analysisDate.month}/${result.analysisDate.year}',
                    style:
                        TextStyle(fontSize: 12, color: Colors.grey[500]),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            // ── All Probabilities ──
            if (result.allProbabilities.isNotEmpty)
              _buildSection(
                title: 'All Probabilities',
                icon: Icons.bar_chart,
                iconColor: Colors.blue,
                child: Column(
                  children: result.allProbabilities.entries
                      .toList()
                      .sorted()
                      .map((e) => Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 130,
                                  child: Text(e.key,
                                      style: const TextStyle(fontSize: 13)),
                                ),
                                Expanded(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(4),
                                    child: LinearProgressIndicator(
                                      value: e.value / 100,
                                      minHeight: 8,
                                      backgroundColor: Colors.grey[200],
                                      valueColor:
                                          AlwaysStoppedAnimation<Color>(
                                              const Color(0xFF4A6FFF)),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  '${e.value.toStringAsFixed(1)}%',
                                  style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                          ))
                      .toList(),
                ),
              ),

            // ── Segmentation images (breast / heart) ──
            if (result.overlayImageBase64 != null)
              _buildSection(
                title: 'Segmentation Overlay',
                icon: Icons.layers,
                iconColor: Colors.purple,
                child: Column(
                  children: [
                    if (result.overlayImageBase64 != null)
                      _buildBase64Image(result.overlayImageBase64!, 'Overlay'),
                    if (result.maskImageBase64 != null) ...[
                      const SizedBox(height: 12),
                      _buildBase64Image(result.maskImageBase64!, 'Mask'),
                    ],
                  ],
                ),
              ),

            // ── Description ──
            if (result.description.isNotEmpty)
              _buildSection(
                title: 'About This Condition',
                icon: Icons.info_outline,
                iconColor: Colors.teal,
                child: Text(
                  result.description,
                  style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                      height: 1.6),
                ),
              ),

            // ── Recommendations ──
            if (result.recommendations.isNotEmpty)
              _buildSection(
                title: 'Recommendations',
                icon: Icons.medical_services_outlined,
                iconColor: const Color(0xFF4A6FFF),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: result.recommendations
                      .map((rec) => _buildBullet(rec, Colors.blue))
                      .toList(),
                ),
              ),

            // ── Emergency Signs ──
            if (result.emergencySigns.isNotEmpty)
              _buildSection(
                title: 'Emergency Warning Signs',
                icon: Icons.warning_amber_rounded,
                iconColor: Colors.red,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: result.emergencySigns
                      .map((s) => _buildBullet(s, Colors.red))
                      .toList(),
                ),
              ),

            // ── Prevention Tips ──
            if (result.preventionTips.isNotEmpty)
              _buildSection(
                title: 'Prevention Tips',
                icon: Icons.shield_outlined,
                iconColor: Colors.green,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: result.preventionTips
                      .map((t) => _buildBullet(t, Colors.green))
                      .toList(),
                ),
              ),

            // ── Actions ──
            Padding(
              padding: const EdgeInsets.all(20),
              child: SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () =>
                      Navigator.popUntil(context, (r) => r.isFirst),
                  icon: const Icon(Icons.home_outlined),
                  label: const Text('Back to Home'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF4A6FFF),
                    side: const BorderSide(color: Color(0xFF4A6FFF)),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required IconData icon,
    required Color iconColor,
    required Widget child,
  }) {
    return Container(
      color: Colors.white,
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: iconColor, size: 20),
              const SizedBox(width: 8),
              Text(title,
                  style: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }

  Widget _buildBullet(String text, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Container(
              width: 7,
              height: 7,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(text,
                style: TextStyle(
                    fontSize: 14, color: Colors.grey[700], height: 1.5)),
          ),
        ],
      ),
    );
  }

  Widget _buildBase64Image(String base64Str, String label) {
    try {
      final Uint8List bytes = base64Decode(base64Str);
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style:
                  TextStyle(fontSize: 12, color: Colors.grey[500])),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.memory(bytes, fit: BoxFit.contain),
          ),
        ],
      );
    } catch (_) {
      return const SizedBox.shrink();
    }
  }
}

extension _SortedEntries on List<MapEntry<String, double>> {
  List<MapEntry<String, double>> sorted() {
    return this..sort((a, b) => b.value.compareTo(a.value));
  }
}
