class PredictionResult {
  final String label;
  final double confidence;

  PredictionResult({
    required this.label,
    required this.confidence,
  });

  @override
  String toString() {
    return '$label: ${(confidence * 100).toStringAsFixed(1)}%';
  }
}
