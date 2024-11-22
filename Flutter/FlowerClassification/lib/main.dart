import 'package:flutter/material.dart';
import 'package:flower_classification_app/screens/flower_classification_screen.dart';
import 'package:flower_classification_app/constants/colors.dart';

void main() {
  runApp(const FlowerClassificationApp());
}

class FlowerClassificationApp extends StatelessWidget {
  const FlowerClassificationApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '꽃 분류 앱',
      theme: ThemeData(
        primaryColor: AppColors.primaryColor,
        scaffoldBackgroundColor: AppColors.backgroundColor,
        fontFamily: 'Pretendard',
      ),
      home: const FlowerClassificationScreen(),
    );
  }
}
