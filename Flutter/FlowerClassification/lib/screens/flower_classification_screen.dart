import 'dart:io';
import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../constants/styles.dart';
import '../models/prediction_result.dart';
import '../widgets/model_selection_widget.dart';
import '../widgets/image_selection_widget.dart';
import '../widgets/prediction_results_widget.dart';

class FlowerClassificationScreen extends StatefulWidget {
  const FlowerClassificationScreen({Key? key}) : super(key: key);

  @override
  State<FlowerClassificationScreen> createState() =>
      _FlowerClassificationScreenState();
}

class _FlowerClassificationScreenState
    extends State<FlowerClassificationScreen> {
  File? _image;
  String _selectedModel = 'EfficientNet';
  bool _isProcessing = false;
  List<PredictionResult> _predictions = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('꽃 분류'),
        backgroundColor: AppColors.primaryColor,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ModelSelectionWidget(
                selectedModel: _selectedModel,
                onModelChanged: (String? newValue) {
                  if (newValue != null) {
                    setState(() => _selectedModel = newValue);
                  }
                },
              ),
              ImageSectionWidget(
                image: _image,
                onImageSelected: (File file) {
                  setState(() {
                    _image = file.path.isEmpty ? null : file;
                    _predictions = [];
                  });
                },
              ),
              _buildPredictButton(),
              if (_predictions.isNotEmpty)
                PredictionResultsWidget(predictions: _predictions),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPredictButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryColor,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      onPressed: _image == null || _isProcessing ? null : _predictFlower,
      child: Text(
        _isProcessing ? '예측 중...' : '예측 시작',
        style: AppStyles.buttonStyle,
      ),
    );
  }

  Future<void> _predictFlower() async {
    setState(() => _isProcessing = true);

    // TODO: 실제 모델 예측 로직 구현
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _predictions = [
        PredictionResult(label: '장미', confidence: 0.95),
        PredictionResult(label: '튤립', confidence: 0.03),
        PredictionResult(label: '데이지', confidence: 0.02),
      ];
      _isProcessing = false;
    });
  }
}
