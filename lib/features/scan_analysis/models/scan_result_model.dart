

class ScanResultModel {
  final String id;
  final String scanType;
  final DateTime scanDate;
  final String imagePath;
  final String notes;
  final String riskLevel; 
  final double confidenceScore;
  final List<Finding> findings;
  final String recommendation;
  final DateTime analysisDate;

  ScanResultModel({
    required this.id,
    required this.scanType,
    required this.scanDate,
    required this.imagePath,
    required this.notes,
    required this.riskLevel,
    required this.confidenceScore,
    required this.findings,
    required this.recommendation,
    required this.analysisDate,
  });

  
  factory ScanResultModel.demoResult({required String scanType}) {
    return ScanResultModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      scanType: scanType,
      scanDate: DateTime.now(),
      imagePath: '',
      notes: '',
      riskLevel: 'low',
      confidenceScore: 98,
      findings: [
        Finding(
          title: 'Regular Edges',
          description: 'The lesion boundaries appear well-defined and regular, a positive indicator.',
          isPositive: true,
        ),
        Finding(
          title: 'Uniform Pigmentation',
          description: 'Color distribution across the area is consistent with no concerning variations.',
          isPositive: true,
        ),
        Finding(
          title: 'No Inflammation',
          description: 'Surrounding tissue shows no signs of active inflammation or redness.',
          isPositive: true,
        ),
      ],
      recommendation: 'Based on this analysis, a routine check-up is recommended in 6 months. Monitor for any changes in size or color.',
      analysisDate: DateTime.now(),
    );
  }
}

class Finding {
  final String title;
  final String description;
  final bool isPositive;

  Finding({
    required this.title,
    required this.description,
    this.isPositive = true,
  });
}