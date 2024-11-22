import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../constants/colors.dart';
import '../constants/styles.dart';
import '../utils/image_utils.dart';

class ImageSectionWidget extends StatelessWidget {
  final File? image;
  final Function(File) onImageSelected;

  const ImageSectionWidget({
    Key? key,
    this.image,
    required this.onImageSelected,
  }) : super(key: key);

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final File originalFile = File(pickedFile.path);
      final File resizedFile = await ImageUtils.resizeImage(originalFile);
      onImageSelected(resizedFile);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16),
      height: 300,
      decoration: AppStyles.CardDecoration,
      child: image == null
          ? _buildImagePickerButton()
          : Stack(
              children: [
                Image.file(image!, fit: BoxFit.contain),
                Positioned(
                  right: 8,
                  top: 8,
                  child: IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => onImageSelected(File('')),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildImagePickerButton() {
    return InkWell(
      onTap: _pickImage,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.add_photo_alternate,
                size: 48, color: AppColors.primaryColor),
            SizedBox(height: 8),
            Text('이미지를 선택하세요', style: AppStyles.resultLabelStyle),
          ],
        ),
      ),
    );
  }
}
