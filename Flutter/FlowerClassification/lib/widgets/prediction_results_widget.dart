import 'package:flutter/material.dart';
import '../constants/styles.dart';
import '../models/prediction_result.dart';

class PredictionResultsWidget extends StatelessWidget {
  final List<PredictionResult> predictions;

  const PredictionResultsWidget({
    Key? key,
    required this.predictions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.all(16),
      decoration: AppStyles.CardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('예측 결과', style: AppStyles.titleStyle),
          const SizedBox(height: 16),
          ...predictions.map((prediction) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(
                prediction.toString(),
                style: AppStyles.resultLabelStyle,
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}
