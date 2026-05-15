class ScanResultModel {
  final String scanType;
  final String imagePath;
  final String predictedClass;
  final String predictedName;
  final double confidence;
  final String severity;
  final Map<String, double> allProbabilities;
  final String description;
  final List<String> recommendations;
  final List<String> emergencySigns;
  final List<String> preventionTips;
  final String? maskImageBase64;
  final String? overlayImageBase64;
  final double? heartAreaPercent;
  final String? assessment;
  final DateTime analysisDate;

  ScanResultModel({
    required this.scanType,
    required this.imagePath,
    required this.predictedClass,
    required this.predictedName,
    required this.confidence,
    required this.severity,
    required this.allProbabilities,
    required this.description,
    required this.recommendations,
    required this.emergencySigns,
    required this.preventionTips,
    this.maskImageBase64,
    this.overlayImageBase64,
    this.heartAreaPercent,
    this.assessment,
    required this.analysisDate,
  });

  factory ScanResultModel.fromApiResponse(
    Map<String, dynamic> json,
    String scanType,
    String imagePath,
  ) {
    final diseaseInfo = json['disease_info'] as Map<String, dynamic>? ?? {};
    final segmentation = json['segmentation'] as Map<String, dynamic>?;

    final rawProbs = json['all_probabilities'] as Map<String, dynamic>? ?? {};
    final probs = rawProbs.map((k, v) => MapEntry(k, (v as num).toDouble()));

    final confidence = (json['confidence'] as num?)?.toDouble() ?? 0.0;
    String severity = json['severity'] as String? ?? '';
    if (severity.isEmpty) {
      if (confidence >= 85) {
        severity = 'high';
      } else if (confidence >= 60) {
        severity = 'medium';
      } else {
        severity = 'low';
      }
    }

    final predictedClass = json['predicted_class'] as String?
        ?? json['assessment'] as String?
        ?? 'Unknown';

    return ScanResultModel(
      scanType: scanType,
      imagePath: imagePath,
      predictedClass: predictedClass,
      predictedName: diseaseInfo['disease_name'] as String? ?? predictedClass,
      confidence: confidence,
      severity: severity,
      allProbabilities: probs,
      description: diseaseInfo['description'] as String? ?? '',
      recommendations: (diseaseInfo['recommendations'] as List?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      emergencySigns: (diseaseInfo['emergency_signs'] as List?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      preventionTips: (diseaseInfo['prevention_tips'] as List?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      maskImageBase64: segmentation?['mask_image_base64'] as String?,
      overlayImageBase64: segmentation?['overlay_image_base64'] as String?,
      heartAreaPercent: (json['heart_area_ratio_percent'] as num?)?.toDouble(),
      assessment: json['assessment'] as String?,
      analysisDate: DateTime.now(),
    );
  }
}
