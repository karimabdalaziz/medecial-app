class ScanModel {
  final String id;
  final String type;
  final DateTime date;
  final String imagePath;
  final String status;
  final double? confidenceScore;
  final String? riskLevel;
  final List<String>? findings;
  final String? recommendation;

  ScanModel({
    required this.id,
    required this.type,
    required this.date,
    required this.imagePath,
    this.status = 'processing',
    this.confidenceScore,
    this.riskLevel,
    this.findings,
    this.recommendation,
  });
}