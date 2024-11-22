import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../constants/styles.dart';

class ModelSelectionWidget extends StatelessWidget {
  final String selectedModel;
  final Function(String?) onModelChanged;

  const ModelSelectionWidget({
    Key? key,
    required this.selectedModel,
    required this.onModelChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: AppStyles.CardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('모델 선택', style: AppStyles.titleStyle),
          const SizedBox(height: 8),
          DropdownButton<String>(
            value: selectedModel,
            isExpanded: true,
            items: ['EfficientNet', 'MobileNet', 'ResNet']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: onModelChanged,
          ),
        ],
      ),
    );
  }
}
